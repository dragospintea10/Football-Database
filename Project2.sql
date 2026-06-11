--First Exercise


create or alter view PlayerClub 
as
select p.PLAYERID as PlayerID,
       p.NAME as PlayerName,
       t.TOCLUB as ClubID,
       c.name as ClubName
FROM
(
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY PlayerID ORDER BY TransferID DESC) AS rn
    FROM TRANSFERS
) t
JOIN PLAYERS p ON p.PlayerID = t.PlayerID
JOIN CLUBS c ON c.ClubID = t.ToClub
WHERE t.rn = 1;
GO

select * from PlayerClub
go



-- Second Exercise



CREATE or alter FUNCTION dbo.GetPlayerClubs (@PlayerID INT)
RETURNS TABLE
AS
RETURN
(
    select
        p.name as PlayerName,
        c.name as Club,
        t.ToClub AS ClubID,
        t.TransferDate AS ContractStart,
        DATEADD(YEAR, t.ContractLenght, t.TransferDate) AS ContractEnd
    from TRANSFERS t
    join PLAYERS p on p.PLAYERID = t.PLAYERID
    join CLUBS c on t.TOCLUB = c.CLUBID
    where t.PlayerID = @PlayerID
)
GO


SELECT * 
FROM GetPlayerClubs(4)

GO



--Third Exercise

-- a)

Create or alter trigger Manager_AIU
on ClubManager
after insert, update
as
begin
    update c
    set c.MANAGERID = cm.ManagerID
    from Clubs c
    join
    (
        select ClubID, ManagerID
        from ClubManager
        where StartDate <= GETDATE()
          and EndDate   >= GETDATE()
    ) cm
        ON c.ClubID = cm.ClubID
    where c.ClubID in (select ClubID from inserted);
end
go


-- b)

create or alter trigger actual_manager
on clubs
after insert
as
begin
    update CLUBS
    set ManagerID = NULL
    From CLUBS c 
    Join inserted i on c.CLUBID = i.CLUBID
end;
go


-- c)

create or alter trigger Manager_Constrain
on clubs
after update
as
begin
    if TRIGGER_NESTLEVEL() = 1
    begin
        if update (managerID)
        begin
            RAISERROR(
                'ERROR: ActualManager cannot be updated directly. Use ClubManager instead.',
                16, 1
            )
            ROLLBACK TRANSACTION
            return
        end
    end
end
go

-- d)

create or alter trigger CM_AD
on ClubManager
after delete
as
begin
    if TRIGGER_NESTLEVEL() > 1
       return;
    update c
    set MANAGERID = NULL
    from CLUBS c
    join deleted d
        on c.CLUBID = d.CLUBID
     where StartDate <= GETDATE()
          and EndDate   >= GETDATE()
          and c.MANAGERID = d.MANAGERID
end
go


--Forth Exercise 

create or alter trigger trg_lineups_AIU
on lineups
instead of insert, update
as
begin
    select * into #tmp_i from inserted
    select * into #tmp_d from deleted
   
    alter table #tmp_i add id int identity(1,1)
    alter table #tmp_d add id int identity(1,1)

    if exists (select 1 
               from #tmp_i i
               join matches m on m.MATCHID = i.MATCHID
               where i.clubid not in (m.HOMECLUB, m.AWAYCLUB)
                    or i.CLUBID <>
             (
                select top 1 t.TOCLUB
                from TRANSFERS t
                where t.PLAYERID = i.PLAYERID
                  and t.TRANSFERDATE <= m.DATEOFMATCH
                order by t.TRANSFERDATE desc
            )
    )
    begin
        RAISERROR(
            'ERROR: Invalid lineup: player does not belong to the club at the match date.',
            16, 1
        )
        return;
end
 UPDATE l
    SET l.POSITION = i.POSITION,
        l.STARTER  = i.STARTER
    FROM LINEUPS l
    JOIN #tmp_i i 
        ON l.PLAYERID = i.PLAYERID
       AND l.CLUBID  = i.CLUBID
       AND l.MATCHID = i.MATCHID;

    INSERT INTO LINEUPS (PLAYERID, CLUBID, MATCHID, POSITION, STARTER)
    SELECT i.PLAYERID, i.CLUBID, i.MATCHID, i.POSITION, i.STARTER
    FROM #tmp_i i
    LEFT JOIN LINEUPS l 
        ON l.PLAYERID = i.PLAYERID
       AND l.CLUBID  = i.CLUBID
       AND l.MATCHID = i.MATCHID
    WHERE l.PLAYERID IS NULL

    DROP TABLE #tmp_i;
    DROP TABLE #tmp_d;
end
go


-- Fifth exercise

create or alter procedure fill_player_stats
as
begin
    insert into PLAYER_MATCH_STATS (
        PLAYERID,
        CLUBID,
        MATCHID,
        GOALSSCORED,
        MINUTESPLAYED,
        PASSESCOMPLETED,
        SHOTSONTARGET)
    select
        l.PLAYERID,
        l.CLUBID,
        l.MATCHID,
        count (case when a.TYPE_OF_ACTION = 'goal' then 1 end) as GoalScored,      
        coalesce(
            min(
                case when a.TYPE_OF_ACTION = 'Exit from match' or a.TYPE_OF_ACTION = 'Received red card' then a.minute end), 
                m.totalminutes)
        -
        case
            when l.STARTER = 1 then 0
            else min(case when a.TYPE_OF_ACTION = 'Enter into match' then a.MINUTE end) 
        end 
        as MinutesPlayed,
        count (case when a.TYPE_OF_ACTION = 'pass done' then 1 end) as PassesCompleted,
        count (case when a.TYPE_OF_ACTION = 'shot on target' then 1 end) as ShotsOnTarget

    from lineups l
    join MATCHES m
        on m.MATCHID = l.MATCHID
    left join ACTIONS a
        on a.MATCHID = l.MATCHID
        and a.PLAYERID = l.PLAYERID
        and a.CLUBID = l.CLUBID
    where m.TOTALMINUTES IS NOT NULL
    group by
        l.PLAYERID,
        l.CLUBID,
        l.MATCHID,
        l.STARTER,
        m.TOTALMINUTES
end     
