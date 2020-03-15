--1--

SELECT player_name FROM player WHERE batting_hand = 'Left-hand bat' and country_name='England' ORDER BY player_name;

--2--

SELECT player_name, CAST(date_part('year', age('2018-02-12',dob)) AS INT) AS player_age FROM player WHERE bowling_skill = 'Legbreak googly' AND CAST(date_part('year', age('2018-02-12',dob)) AS INT) >= 28 ORDER BY CAST(date_part('year', age('2018-02-12',dob)) AS INT) DESC, player_name ASC;

--3--

SELECT match_id, toss_winner FROM MATCH WHERE toss_decision = 'bat' ORDER BY match_id;


--4--

SELECT over_id, sum(runs_scored) AS runs_scored FROM (SELECT match_id, over_id, ball_id, innings_no, runs_scored FROM batsman_scored UNION ALL SELECT match_id, over_id, ball_id, innings_no ,extra_runs FROM extra_runs) AS derived_table WHERE match_id=335987 GROUP BY over_id, innings_no HAVING sum(runs_scored)<=7 ORDER BY sum(runs_scored) DESC, over_id ASC;

--5--

SELECT player_name FROM player WHERE player_id IN (SELECT player_out FROM ( SELECT * FROM wicket_taken WHERE kind_out = 'bowled' ) AS derived_table GROUP BY player_out HAVING COUNT(kind_out) >= 1) ORDER BY player_name;

--6--

SELECT match_id, t1.name AS team_1 , t2.name AS team_2, t3.name AS winning_team_name, win_margin FROM MATCH m INNER JOIN team t1 ON t1.team_id = m.team_1 INNER JOIN team t2 ON t2.team_id=m.team_2 INNER JOIN team t3 ON t3.team_id=m.match_winner WHERE m.win_margin>=60 ORDER BY win_margin ASC , match_id ASC;

--7--

SELECT player_name FROM player WHERE batting_hand = 'Left-hand bat' AND CAST(date_part('year', age('2018-02-12',dob)) AS INT) < 30 ORDER BY player_name;

--8--

SELECT match_id, SUM(runs_scored) as total_runs FROM (SELECT match_id, over_id, ball_id, runs_scored FROM batsman_scored UNION ALL SELECT match_id, over_id, ball_id, extra_runs FROM extra_runs) AS derived_table GROUP BY match_id ORDER BY match_id;

--9--

SELECT match_id, runs AS maximum_runs, player_name FROM player, (SELECT * FROM (SELECT match_id, over_id, innings_no, bowler FROM ball_by_ball) AS tt1   NATURAL JOIN  (SELECT match_id, over_id, innings_no, runs FROM ( SELECT match_id, over_id, innings_no, SUM(runs_scored) AS runs FROM (SELECT match_id, over_id, ball_id, innings_no, runs_scored FROM batsman_scored UNION ALL SELECT match_id, over_id, ball_id, innings_no, extra_runs FROM extra_runs) AS tb GROUP BY match_id, over_id, innings_no) AS tb1 WHERE (match_id, runs) IN  ( SELECT match_id, MAX(runs) FROM ( SELECT match_id, over_id, innings_no, SUM(runs_scored) AS runs FROM (SELECT match_id, over_id, ball_id, innings_no, runs_scored FROM batsman_scored UNION ALL SELECT match_id, over_id, ball_id, innings_no, extra_runs FROM extra_runs) AS tb3 GROUP BY match_id, over_id, innings_no) AS tb4 GROUP BY match_id)) AS tt2 GROUP BY match_id, over_id, innings_no, bowler, runs) AS final_table WHERE final_table.bowler = player_id ORDER BY match_id, over_id;

--10--

SELECT player_name,number FROM player, (SELECT t1.player_id, COUNT(kind_out) AS number FROM  (SELECT player_id FROM player) AS t1 FULL OUTER JOIN (SELECT player_out, kind_out FROM wicket_taken WHERE kind_out = 'run out') AS t2 ON t1.player_id = t2.player_out GROUP BY t1.player_id) AS ft WHERE player.player_id = ft.player_id ORDER BY number DESC, player_name ASC; 

--11--

SELECT wt.kind_out AS out_type, count(p.player_name) AS number  FROM wicket_taken AS wt, player AS p WHERE wt.player_out=p.player_id GROUP BY wt.kind_out HAVING count(p.player_name)>=0 ORDER BY COUNT(p.player_name) DESC, out_type ASC;

--12--

SELECT team.name AS name, t2.number AS number FROM team , (SELECT pm.team_id AS tid, count(man_of_the_match) AS number FROM MATCH AS m, player_match AS pm WHERE m.match_id=pm.match_id AND m.man_of_the_match=pm.player_id GROUP BY pm.team_id HAVING count(m.man_of_the_match)>=0) AS t2 WHERE team.team_id=t2.tid ORDER BY team.name;

--13--

SELECT MIN(venue) AS venue FROM (SELECT match_id, venue FROM match) AS d_tb1 NATURAL JOIN (SELECT match_id, extra_type FROM extra_runs WHERE extra_type = 'wides') AS d_tb2 GROUP BY venue HAVING COUNT(extra_type) IN (SELECT MAX(wide_no) FROM (SELECT venue, COUNT(extra_type) AS wide_no FROM (SELECT match_id, venue FROM match) AS d_tb3 NATURAL JOIN (SELECT match_id, extra_type FROM extra_runs WHERE extra_type = 'wides') AS d_tb4 GROUP BY venue) AS d_tb5);

--14--

SELECT venue FROM MATCH WHERE (toss_decision='bat' AND toss_winner!=match_winner) OR (toss_decision='field' AND toss_winner=match_winner) GROUP BY venue ORDER BY COUNT(match_id) DESC, venue ASC;

--15--

SELECT player_name FROM player WHERE player_id IN (SELECT tb4.bowler FROM (SELECT bowler, SUM(runs_scored) AS runs_scored FROM (SELECT match_id, over_id, ball_id, innings_no, bowler FROM ball_by_ball) AS tb1 NATURAL JOIN (SELECT match_id, over_id, ball_id, innings_no, SUM(runs_scored) AS runs_scored FROM (SELECT match_id, over_id, ball_id, innings_no, runs_scored FROM batsman_scored UNION ALL SELECT match_id, over_id, ball_id, innings_no ,extra_runs FROM extra_runs) AS tb2 GROUP BY match_id, over_id, ball_id, innings_no) AS tb3 GROUP BY bowler) AS tb4 FULL OUTER JOIN (SELECT bowler, COUNT(player_out) AS wickets_taken FROM (SELECT match_id, over_id, ball_id, innings_no, player_out FROM wicket_taken) AS tb5 NATURAL JOIN (SELECT match_id, over_id, ball_id, innings_no, bowler FROM ball_by_ball) AS tb6 GROUP BY bowler) AS tb7 ON tb4.bowler = tb7.bowler WHERE ROUND(runs_scored / wickets_taken, 3) IN (SELECT MIN(avg) FROM (SELECT ROUND(runs_scored / wickets_taken, 3) AS AVG FROM (SELECT bowler, SUM(runs_scored) AS runs_scored FROM (SELECT match_id, over_id, ball_id, innings_no, bowler FROM ball_by_ball) AS tb8 NATURAL JOIN (SELECT match_id, over_id, ball_id, innings_no, SUM(runs_scored) AS runs_scored FROM (SELECT match_id, over_id, ball_id, innings_no, runs_scored FROM batsman_scored UNION ALL SELECT match_id, over_id, ball_id, innings_no ,extra_runs FROM extra_runs) AS tb9 GROUP BY match_id, over_id, ball_id, innings_no) AS tb10 GROUP BY bowler) AS tb11 FULL OUTER JOIN (SELECT bowler, COUNT(player_out) AS wickets_taken FROM (SELECT match_id, over_id, ball_id, innings_no, player_out FROM wicket_taken) AS tb12 NATURAL JOIN (SELECT match_id, over_id, ball_id, innings_no, bowler FROM ball_by_ball) AS tb13 GROUP BY bowler) AS tb14 ON tb11.bowler = tb14.bowler WHERE tb14.wickets_taken IS NOT NULL) AS tb15)) ORDER BY player_name;

--16--

SELECT p.player_name AS player_name, t.name AS name FROM player AS p, team AS t, (SELECT pm.player_id AS pid, pm.team_id AS tid FROM player_match AS pm , MATCH AS m WHERE pm.role='CaptainKeeper' AND pm.match_id=m.match_id AND pm.team_id=m.match_winner) AS temp WHERE p.player_id=pid AND t.team_id=tid ORDER BY p.player_name ASC, t.name ASC;

--17--

SELECT player_name, runs_scored FROM player, (SELECT match_id, striker, SUM(runs_scored) AS runs_scored FROM batsman_scored NATURAL JOIN (SELECT match_id, over_id, ball_id, innings_no, striker FROM ball_by_ball) AS t1 GROUP BY match_id, striker) AS ft WHERE player_id = striker AND runs_scored >= 50 ORDER BY runs_scored DESC, player_name ASC;

--18--

SELECT p.player_name AS player_name FROM player AS p, (SELECT DISTINCT pm.player_id AS player_id FROM player_match AS pm, MATCH AS m, (SELECT bb.match_id AS match_id , bb.striker AS player_id FROM ball_by_ball AS bb, batsman_scored AS bs WHERE bb.over_id=bs.over_id AND bb.ball_id=bs.ball_id AND bb.innings_no=bs.innings_no AND bb.match_id=bs.match_id GROUP BY bb.match_id, bb.striker HAVING sum(bs.runs_scored)>=100) AS t WHERE pm.player_id=t.player_id AND pm.match_id=t.match_id AND t.match_id=m.match_id AND pm.team_id!=m.match_winner)  AS t1 WHERE t1.player_id=p.player_id ORDER BY p.player_name;

--19--

SELECT match_id , venue FROM MATCH AS m WHERE (m.team_1=(SELECT team_id FROM team WHERE name= 'Kolkata Knight Riders') OR m.team_2=(SELECT team_id FROM team WHERE name= 'Kolkata Knight Riders' )) AND m.match_winner!=(SELECT team_id FROM team WHERE name= 'Kolkata Knight Riders') ORDER BY match_id;

--20--

SELECT player_name FROM player, (SELECT striker, CAST(SUM(runs_scored) AS float) AS runs_count FROM match, (SELECT * FROM ( SELECT match_id, over_id, ball_id, innings_no, striker FROM ball_by_ball) AS t1 NATURAL JOIN  batsman_scored) AS nt1 WHERE match.match_id = nt1.match_id AND match.season_id = 5 GROUP BY striker) AS dt1 FULL OUTER JOIN  (SELECT striker, COUNT(DISTINCT tt.match_id) AS match_count FROM match, (SELECT match_id, striker FROM ball_by_ball UNION SELECT match_id, non_striker FROM ball_by_ball) AS tt WHERE match.match_id = tt.match_id AND match.season_id = 5 GROUP BY striker) AS dt2 ON dt1.striker = dt2.striker WHERE player_id = dt1.striker AND match_count IS NOT NULL ORDER BY CAST( runs_count/match_count AS decimal(10,3)) DESC, player_name ASC LIMIT 10;

--21--

SELECT country_name FROM( SELECT n_tb1.country_name AS country_name, CAST( country_avg/country_sum AS decimal(10,3)) AS country_avg FROM (SELECT country_name, COUNT(player_id) AS country_sum FROM player GROUP BY country_name) AS n_tb1 FULL OUTER JOIN (SELECT country_name, SUM(average) AS country_avg FROM ( SELECT dt1.striker, CAST( runs_count/match_count AS decimal(10,3)) AS average FROM (SELECT striker, CAST(SUM(runs_scored) AS float) AS runs_count FROM (SELECT match_id, over_id, ball_id, innings_no, striker FROM ball_by_ball) AS t1 NATURAL JOIN  batsman_scored GROUP BY striker) AS dt1 FULL OUTER JOIN  (SELECT striker, COUNT(DISTINCT match_id) AS match_count FROM (SELECT match_id, striker FROM ball_by_ball UNION SELECT match_id, non_striker FROM ball_by_ball) AS tt GROUP BY striker) AS dt2 ON dt1.striker = dt2.striker) AS nt3 JOIN (SELECT player_id, country_name FROM player) AS nt2 ON nt3.striker = nt2.player_id GROUP BY country_name) AS n_tb2 ON n_tb1.country_name = n_tb2.country_name ORDER BY CAST( country_avg/country_sum AS decimal(10,3)) DESC  LIMIT 5) AS final_table ORDER BY country_avg DESC, country_name ASC;
