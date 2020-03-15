CREATE TABLE player ( player_id INTEGER NOT NULL PRIMARY key, player_name varchar(255), dob date, batting_hand varchar(255), bowling_skill varchar(255), country_name varchar(255));
CREATE TABLE MATCH ( match_id INTEGER NOT NULL PRIMARY key, team_1 integer, team_2 integer, match_date date, season_id INTEGER , venue varchar(255), toss_winner integer, toss_decision varchar(255), win_type varchar(255), win_margin integer, outcome_type varchar(255), match_winner integer, man_of_the_match integer, CONSTRAINT chk_season CHECK (season_id <=9 AND season_id >=1) );
CREATE TABLE team (team_id INTEGER NOT NULL PRIMARY key, name varchar(255));
CREATE TABLE player_match (match_id INTEGER NOT null, player_id INTEGER NOT null, role varchar(255), team_id INTEGER ,   CONSTRAINT player_match_PK PRIMARY KEY (match_id, player_id));
CREATE TABLE ball_by_ball (match_id INTEGER NOT null, over_id INTEGER NOT null, ball_id INTEGER NOT null, innings_no INTEGER NOT null, team_batting INTEGER , team_bowling integer, striker_batting_position integer, striker integer, non_striker integer, bowler integer,  CONSTRAINT ball_by_ball_PK PRIMARY KEY (match_id, over_id, ball_id, innings_no) , CONSTRAINT chk_overid CHECK (over_id<=20 AND over_id >=1 ), CONSTRAINT chk_ballid CHECK (ball_id<=9 AND ball_id >=1 ),CONSTRAINT chk_innings_no CHECK (innings_no<=4 AND innings_no >=1 )  );
CREATE TABLE batsman_scored (match_id INTEGER NOT null, over_id INTEGER NOT null, ball_id INTEGER NOT null, runs_scored integer, innings_no INTEGER NOT null, CONSTRAINT batsman_scored_PK PRIMARY KEY (match_id, over_id, ball_id, innings_no));
CREATE TABLE extra_runs( match_id INTEGER NOT NULL, over_id INTEGER NOT NULL, ball_id INTEGER NOT NULL, extra_type VARCHAR(255), extra_runs INTEGER, innings_no INTEGER NOT NULL, CONSTRAINT extra_runs_PK PRIMARY KEY(match_id, over_id, ball_id, innings_no));
CREATE TABLE wicket_taken( match_id INTEGER NOT NULL, over_id INTEGER NOT NULL, ball_id INTEGER NOT NULL, player_out INTEGER, kind_out VARCHAR(255), innings_no INTEGER NOT NULL, CONSTRAINT wicket_taken_PK PRIMARY KEY(match_id, over_id, ball_id, innings_no));