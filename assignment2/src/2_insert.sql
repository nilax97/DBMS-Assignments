copy player(player_id, player_name, dob, batting_hand, bowling_skill, country_name) FROM 'player.csv' WITH DELIMITER ','; 

copy team(team_id, name) FROM 'team.csv' WITH DELIMITER ','; 

copy match(match_id, team_1, team_2, match_date, season_id, venue, toss_winner, toss_decision, win_type, win_margin, outcome_type, match_winner, man_of_the_match) FROM 'match.csv' WITH DELIMITER ',';

copy player_match(match_id, player_id, role, team_id) FROM 'player_match.csv' WITH DELIMITER ',';

copy ball_by_ball(match_id, over_id, ball_id, innings_no, team_batting, team_bowling, striker_batting_position, striker, non_striker, bowler) FROM 'ball_by_ball.csv' WITH DELIMITER ',';

copy batsman_scored(match_id, over_id, ball_id, runs_scored, innings_no) FROM 'batsman_scored.csv' WITH DELIMITER ',';

copy wicket_taken(match_id, over_id, ball_id, player_out, kind_out, innings_no) FROM 'wicket_taken.csv' WITH DELIMITER ',';

copy extra_runs(match_id, over_id, ball_id, extra_type, extra_runs, innings_no) FROM 'extra_runs.csv' WITH DELIMITER ',';



