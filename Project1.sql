/*==============================================================*/
/* DBMS name:      Sybase SQL Anywhere 12                       */
/* Created on:     10/19/2025 11:44:44 PM                       */
/*==============================================================*/


if exists(select 1 from sys.sysforeignkey where role='FK_ACTIONS_RELATIONS_LINEUP') then
    alter table ACTIONS
       delete foreign key FK_ACTIONS_RELATIONS_LINEUP
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_CLUB_YEARLY_PA_SEASON') then
    alter table CLUB
       delete foreign key FK_CLUB_YEARLY_PA_SEASON
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_LINEUP_LINEUPS_MATCH') then
    alter table LINEUP
       delete foreign key FK_LINEUP_LINEUPS_MATCH
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_LINEUP_USED_PLAY_PLAYER') then
    alter table LINEUP
       delete foreign key FK_LINEUP_USED_PLAY_PLAYER
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_MANAGEME_PREVIOUS__CLUB') then
    alter table MANAGEMENT
       delete foreign key FK_MANAGEME_PREVIOUS__CLUB
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_MATCH_AWAY_CLUB_CLUB') then
    alter table "MATCH"
       delete foreign key FK_MATCH_AWAY_CLUB_CLUB
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_MATCH_HOME_CLUB_CLUB') then
    alter table "MATCH"
       delete foreign key FK_MATCH_HOME_CLUB_CLUB
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_MATCH_SEASON_GA_SEASON') then
    alter table "MATCH"
       delete foreign key FK_MATCH_SEASON_GA_SEASON
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_PLAYER_ROSTER_CLUB') then
    alter table PLAYER
       delete foreign key FK_PLAYER_ROSTER_CLUB
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_SEASON_YEAR_COMPETIT') then
    alter table SEASON
       delete foreign key FK_SEASON_YEAR_COMPETIT
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_TRANSFER_FROM_CLUB_CLUB') then
    alter table TRANSFER
       delete foreign key FK_TRANSFER_FROM_CLUB_CLUB
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_TRANSFER_PLAYER_TR_PLAYER') then
    alter table TRANSFER
       delete foreign key FK_TRANSFER_PLAYER_TR_PLAYER
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_TRANSFER_RELATIONS_CLUB') then
    alter table TRANSFER
       delete foreign key FK_TRANSFER_RELATIONS_CLUB
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_TROPHY_CLUB_TITL_CLUB') then
    alter table TROPHY
       delete foreign key FK_TROPHY_CLUB_TITL_CLUB
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_TROPHY_WINNER_SEASON') then
    alter table TROPHY
       delete foreign key FK_TROPHY_WINNER_SEASON
end if;

drop index if exists ACTIONS.RELATIONSHIP_18_FK;

drop index if exists ACTIONS.ACTIONS_PK;

drop table if exists ACTIONS;

drop index if exists CLUB.YEARLY_PARTICIPANTS_FK;

drop index if exists CLUB.CLUB_PK;

drop table if exists CLUB;

drop index if exists COMPETITION.COMPETITION_PK;

drop table if exists COMPETITION;

drop index if exists LINEUP.RELATIONSHIP_17_FK;

drop index if exists LINEUP.LINEUPS_FK;

drop index if exists LINEUP.LINEUP_PK;

drop table if exists LINEUP;

drop index if exists MANAGEMENT.PREVIOUS_MANAGERS_FK;

drop index if exists MANAGEMENT.PAST_MANAGEMENT_PK;

drop table if exists MANAGEMENT;

drop index if exists "MATCH".HOME_CLUB_FK;

drop index if exists "MATCH".AWAY_CLUB_FK;

drop index if exists "MATCH".SEASON_GAMES_FK;

drop index if exists "MATCH".MATCH_PK;

drop table if exists "MATCH";

drop index if exists PLAYER.ROSTER_FK;

drop index if exists PLAYER.PLAYER_PK;

drop table if exists PLAYER;

drop index if exists SEASON.YEAR_FK;

drop index if exists SEASON.SEASON_PK;

drop table if exists SEASON;

drop index if exists STATISTICS.STATISTICS_PK;

drop table if exists STATISTICS;

drop index if exists TRANSFER.RELATIONSHIP_16_FK;

drop index if exists TRANSFER.FROM_CLUB_FK;

drop index if exists TRANSFER.PLAYER_TRANSFERS_FK;

drop index if exists TRANSFER.TRANSFER_PK;

drop table if exists TRANSFER;

drop index if exists TROPHY.WINNER_FK;

drop index if exists TROPHY.CLUB_TITLES_FK;

drop index if exists TROPHY.TROPHY_PK;

drop table if exists TROPHY;

/*==============================================================*/
/* Table: ACTIONS                                               */
/*==============================================================*/
create table ACTIONS 
(
   ACTIONID             integer                        not null,
   LINEUPID             integer                        null,
   GAME_TIME            time                           not null,
   ACTION_TYPE          varchar(20)                    not null,
   constraint PK_ACTIONS primary key (ACTIONID)
);

/*==============================================================*/
/* Index: ACTIONS_PK                                            */
/*==============================================================*/
create unique index ACTIONS_PK on ACTIONS (
ACTIONID ASC
);

/*==============================================================*/
/* Index: RELATIONSHIP_18_FK                                    */
/*==============================================================*/
create index RELATIONSHIP_18_FK on ACTIONS (
LINEUPID ASC
);

/*==============================================================*/
/* Table: CLUB                                                  */
/*==============================================================*/
create table CLUB 
(
   CLUBID               integer                        not null,
   COMPETITIONID        integer                        not null,
   SEASONID             integer                        not null,
   CLUB_NAME            varchar(30)                    not null,
   CLUB_COUNTRY         varchar(20)                    not null,
   FOUNDATION_YEAR      date                           not null,
   constraint PK_CLUB primary key (CLUBID)
);

/*==============================================================*/
/* Index: CLUB_PK                                               */
/*==============================================================*/
create unique index CLUB_PK on CLUB (
CLUBID ASC
);

/*==============================================================*/
/* Index: YEARLY_PARTICIPANTS_FK                                */
/*==============================================================*/
create index YEARLY_PARTICIPANTS_FK on CLUB (
COMPETITIONID ASC,
SEASONID ASC
);

/*==============================================================*/
/* Table: COMPETITION                                           */
/*==============================================================*/
create table COMPETITION 
(
   COMPETITIONID        integer                        not null,
   TYPE                 varchar(30)                    not null,
   COMPETITION_COUNTRY  varchar(30)                    not null,
   COMPTETITION_NAME    varchar(30)                    not null,
   constraint PK_COMPETITION primary key (COMPETITIONID)
);

/*==============================================================*/
/* Index: COMPETITION_PK                                        */
/*==============================================================*/
create unique index COMPETITION_PK on COMPETITION (
COMPETITIONID ASC
);

/*==============================================================*/
/* Table: LINEUP                                                */
/*==============================================================*/
create table LINEUP 
(
   LINEUPID             integer                        not null,
   PLAYERID             integer                        not null,
   MATCHID              integer                        not null,
   POSITION             varchar(20)                    not null,
   STARTING_SUB         varchar(10)                    null,
   constraint PK_LINEUP primary key (LINEUPID)
);

/*==============================================================*/
/* Index: LINEUP_PK                                             */
/*==============================================================*/
create unique index LINEUP_PK on LINEUP (
LINEUPID ASC
);

/*==============================================================*/
/* Index: LINEUPS_FK                                            */
/*==============================================================*/
create index LINEUPS_FK on LINEUP (
MATCHID ASC
);

/*==============================================================*/
/* Index: RELATIONSHIP_17_FK                                    */
/*==============================================================*/
create index RELATIONSHIP_17_FK on LINEUP (
PLAYERID ASC
);

/*==============================================================*/
/* Table: MANAGEMENT                                            */
/*==============================================================*/
create table MANAGEMENT 
(
   MANAGEMENTID         integer                        not null,
   CLUBID               integer                        not null,
   PREVIOUS_MANAGER     varchar(30)                    not null,
   STARTING_DATE        date                           not null,
   ENDING_DATE          date                           null,
   M_NAME               varchar(30)                    null,
   M_AGE                integer                        null,
   M_BIRTHDATE          date                           null,
   M_NATIONALITY        varchar(30)                    null,
   STATUS               VBIN                           null,
   constraint PK_MANAGEMENT primary key (MANAGEMENTID)
);

/*==============================================================*/
/* Index: PAST_MANAGEMENT_PK                                    */
/*==============================================================*/
create unique index PAST_MANAGEMENT_PK on MANAGEMENT (
MANAGEMENTID ASC
);

/*==============================================================*/
/* Index: PREVIOUS_MANAGERS_FK                                  */
/*==============================================================*/
create index PREVIOUS_MANAGERS_FK on MANAGEMENT (
CLUBID ASC
);

/*==============================================================*/
/* Table: "MATCH"                                               */
/*==============================================================*/
create table "MATCH" 
(
   MATCHID              integer                        not null,
   COMPETITIONID        integer                        not null,
   SEASONID             integer                        not null,
   HOME_CLUBID          integer                        not null,
   AWAY_CLUBID          integer                        not null,
   MATCHDAY             integer                        not null,
   MATCH_DATE           timestamp                      not null,
   MATCH_ATTENDANCE     integer                        null,
   constraint PK_MATCH primary key (MATCHID)
);

/*==============================================================*/
/* Index: MATCH_PK                                              */
/*==============================================================*/
create unique index MATCH_PK on "MATCH" (
MATCHID ASC
);

/*==============================================================*/
/* Index: SEASON_GAMES_FK                                       */
/*==============================================================*/
create index SEASON_GAMES_FK on "MATCH" (
COMPETITIONID ASC,
SEASONID ASC
);

/*==============================================================*/
/* Index: AWAY_CLUB_FK                                          */
/*==============================================================*/
create index AWAY_CLUB_FK on "MATCH" (
AWAY_CLUBID ASC
);

/*==============================================================*/
/* Index: HOME_CLUB_FK                                          */
/*==============================================================*/
create index HOME_CLUB_FK on "MATCH" (
HOME_CLUBID ASC
);

/*==============================================================*/
/* Table: PLAYER                                                */
/*==============================================================*/
create table PLAYER 
(
   PLAYERID             integer                        not null,
   CLUBID               integer                        not null,
   PLAYER_NAME          varchar(50)                    not null,
   PLAYER_NATIONALITY   varchar(20)                    not null,
   PLAYER_BIRTHDATE     date                           not null,
   PLAYER_HEIGHT        float                          not null,
   PLAYER_WEIGHT        float                          not null,
   PLAYER_MARKET_VALUE  integer                        not null,
   constraint PK_PLAYER primary key (PLAYERID)
);

/*==============================================================*/
/* Index: PLAYER_PK                                             */
/*==============================================================*/
create unique index PLAYER_PK on PLAYER (
PLAYERID ASC
);

/*==============================================================*/
/* Index: ROSTER_FK                                             */
/*==============================================================*/
create index ROSTER_FK on PLAYER (
CLUBID ASC
);

/*==============================================================*/
/* Table: SEASON                                                */
/*==============================================================*/
create table SEASON 
(
   COMPETITIONID        integer                        not null,
   SEASONID             integer                        not null,
   START_DATE_SEASON    date                           not null,
   FINISH_DATE_SEASON   date                           not null,
   SEASON_YEAR          date                           not null,
   constraint PK_SEASON primary key (COMPETITIONID, SEASONID)
);

/*==============================================================*/
/* Index: SEASON_PK                                             */
/*==============================================================*/
create unique index SEASON_PK on SEASON (
COMPETITIONID ASC,
SEASONID ASC
);

/*==============================================================*/
/* Index: YEAR_FK                                               */
/*==============================================================*/
create index YEAR_FK on SEASON (
COMPETITIONID ASC
);

/*==============================================================*/
/* Table: STATISTICS                                            */
/*==============================================================*/
create table STATISTICS 
(
   STATISTICSID         integer                        not null,
   MINUTES_PLAYED       integer                        not null,
   PASSES               integer                        not null,
   SHOTS                integer                        not null,
   GOALS                integer                        not null,
   constraint PK_STATISTICS primary key (STATISTICSID)
);

/*==============================================================*/
/* Index: STATISTICS_PK                                         */
/*==============================================================*/
create unique index STATISTICS_PK on STATISTICS (
STATISTICSID ASC
);

/*==============================================================*/
/* Table: TRANSFER                                              */
/*==============================================================*/
create table TRANSFER 
(
   TRANSFERID           integer                        not null,
   PLAYERID             integer                        not null,
   FROM_CLUBID          integer                        not null,
   TO_CLUBID            integer                        not null,
   TRANSFER_FEE         integer                        not null,
   CONTRACT_LENGTH      timestamp                      not null,
   TRANSFER_DATE        timestamp                      not null,
   constraint PK_TRANSFER primary key (TRANSFERID)
);

/*==============================================================*/
/* Index: TRANSFER_PK                                           */
/*==============================================================*/
create unique index TRANSFER_PK on TRANSFER (
TRANSFERID ASC
);

/*==============================================================*/
/* Index: PLAYER_TRANSFERS_FK                                   */
/*==============================================================*/
create index PLAYER_TRANSFERS_FK on TRANSFER (
PLAYERID ASC
);

/*==============================================================*/
/* Index: FROM_CLUB_FK                                          */
/*==============================================================*/
create index FROM_CLUB_FK on TRANSFER (
FROM_CLUBID ASC
);

/*==============================================================*/
/* Index: RELATIONSHIP_16_FK                                    */
/*==============================================================*/
create index RELATIONSHIP_16_FK on TRANSFER (
TO_CLUBID ASC
);

/*==============================================================*/
/* Table: TROPHY                                                */
/*==============================================================*/
create table TROPHY 
(
   CLUBID               integer                        not null,
   TROPHYID             integer                        not null,
   COMPETITIONID        integer                        not null,
   SEASONID             integer                        not null,
   TROPHY_NAME          varchar(30)                    not null,
   constraint PK_TROPHY primary key (CLUBID, TROPHYID)
);

/*==============================================================*/
/* Index: TROPHY_PK                                             */
/*==============================================================*/
create unique index TROPHY_PK on TROPHY (
CLUBID ASC,
TROPHYID ASC
);

/*==============================================================*/
/* Index: CLUB_TITLES_FK                                        */
/*==============================================================*/
create index CLUB_TITLES_FK on TROPHY (
CLUBID ASC
);

/*==============================================================*/
/* Index: WINNER_FK                                             */
/*==============================================================*/
create index WINNER_FK on TROPHY (
COMPETITIONID ASC,
SEASONID ASC
);

alter table ACTIONS
   add constraint FK_ACTIONS_RELATIONS_LINEUP foreign key (LINEUPID)
      references LINEUP (LINEUPID)
      on update restrict
      on delete restrict;

alter table CLUB
   add constraint FK_CLUB_YEARLY_PA_SEASON foreign key (COMPETITIONID, SEASONID)
      references SEASON (COMPETITIONID, SEASONID)
      on update restrict
      on delete restrict;

alter table LINEUP
   add constraint FK_LINEUP_LINEUPS_MATCH foreign key (MATCHID)
      references "MATCH" (MATCHID)
      on update restrict
      on delete restrict;

alter table LINEUP
   add constraint FK_LINEUP_USED_PLAY_PLAYER foreign key (PLAYERID)
      references PLAYER (PLAYERID)
      on update restrict
      on delete restrict;

alter table MANAGEMENT
   add constraint FK_MANAGEME_PREVIOUS__CLUB foreign key (CLUBID)
      references CLUB (CLUBID)
      on update restrict
      on delete restrict;

alter table "MATCH"
   add constraint FK_MATCH_AWAY_CLUB_CLUB foreign key (AWAY_CLUBID)
      references CLUB (CLUBID)
      on update restrict
      on delete restrict;

alter table "MATCH"
   add constraint FK_MATCH_HOME_CLUB_CLUB foreign key (HOME_CLUBID)
      references CLUB (CLUBID)
      on update restrict
      on delete restrict;

alter table "MATCH"
   add constraint FK_MATCH_SEASON_GA_SEASON foreign key (COMPETITIONID, SEASONID)
      references SEASON (COMPETITIONID, SEASONID)
      on update restrict
      on delete restrict;

alter table PLAYER
   add constraint FK_PLAYER_ROSTER_CLUB foreign key (CLUBID)
      references CLUB (CLUBID)
      on update restrict
      on delete restrict;

alter table SEASON
   add constraint FK_SEASON_YEAR_COMPETIT foreign key (COMPETITIONID)
      references COMPETITION (COMPETITIONID)
      on update restrict
      on delete restrict;

alter table TRANSFER
   add constraint FK_TRANSFER_FROM_CLUB_CLUB foreign key (FROM_CLUBID)
      references CLUB (CLUBID)
      on update restrict
      on delete restrict;

alter table TRANSFER
   add constraint FK_TRANSFER_PLAYER_TR_PLAYER foreign key (PLAYERID)
      references PLAYER (PLAYERID)
      on update restrict
      on delete restrict;

alter table TRANSFER
   add constraint FK_TRANSFER_RELATIONS_CLUB foreign key (TO_CLUBID)
      references CLUB (CLUBID)
      on update restrict
      on delete restrict;

alter table TROPHY
   add constraint FK_TROPHY_CLUB_TITL_CLUB foreign key (CLUBID)
      references CLUB (CLUBID)
      on update restrict
      on delete restrict;

alter table TROPHY
   add constraint FK_TROPHY_WINNER_SEASON foreign key (COMPETITIONID, SEASONID)
      references SEASON (COMPETITIONID, SEASONID)
      on update restrict
      on delete restrict;

