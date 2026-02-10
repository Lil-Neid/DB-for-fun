#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=worldcup --no-align --tuples-only -c"

# Do not change code above this line. Use the PSQL variable above to query your database.

echo -e "\nTotal number of goals in all games from winning teams:"
echo "$($PSQL "SELECT SUM(winner_goals) FROM games")"

echo -e "\nTotal number of goals in all games from both teams combined:"
echo "$($PSQL "SELECT SUM(winner_goals) + SUM(opponent_goals) FROM games")"

echo -e "\nAverage number of goals in all games from the winning teams:"
echo "$($PSQL "SELECT AVG(winner_goals) FROM games")"

echo -e "\nAverage number of goals in all games from the winning teams rounded to two decimal places:"
echo "$($PSQL "SELECT ROUND(AVG(winner_goals),2) FROM games")"

echo -e "\nAverage number of goals in all games from both teams:"
echo "$($PSQL "SELECT AVG(winner_goals + opponent_goals) FROM games")"

echo -e "\nMost goals scored in a single game by one team:"
echo "$($PSQL "SELECT MAX(
  CASE 
    WHEN winner_goals >= opponent_goals THEN winner_goals
    ELSE opponent_goals
  END
) from games")"

echo -e "\nNumber of games where the winning team scored more than two goals:"
echo  "$($PSQL "SELECT count(*) FROM games where winner_goals > 2")"

echo -e "\nWinner of the 2018 tournament team name:"
echo "$($PSQL "
SELECT t.name 
FROM teams as t
left join games as g
on t.team_id= g.winner_id 
where g.round = 'Final' and g.winner_goals > g.opponent_goals and g.year = 2018
order by t.name
")"

echo -e "\nList of teams who played in the 2014 'Eighth-Final' round:"
echo "$($PSQL "
SELECT t.name 
FROM teams as t
left join games as g
on t.team_id= g.winner_id or t.team_id = g.opponent_id
where g.round = 'Eighth-Final' and g.year = 2014
order by t.name")"

echo -e "\nList of unique winning team names in the whole data set:"
echo  "$($PSQL " select distinct 
t.name
from teams as t
inner join games as g
on t.team_id = g.winner_id
order by t.name")"

echo -e "\nYear and team name of all the champions:"
echo "$($PSQL "
SELECT g.year || '|' || t.name 
FROM teams as t
left join games as g
on t.team_id= g.winner_id 
where g.round = 'Final' and g.winner_goals > g.opponent_goals
order by g.year
")"

echo -e "\nList of teams that start with 'Co':"
echo "$($PSQL "SELECT name FROM teams where name like 'Co%' ")"
