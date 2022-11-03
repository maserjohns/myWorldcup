#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "truncate games,teams")

cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  TEAM_W=$($PSQL "select name from teams where name='$WINNER' ")
  if [[ $WINNER != "winner" ]]
   then
    if [[ -z $TEAM_W ]]
      then
      INSERT_TEAM_W=$($PSQL "insert into teams(name) values('$WINNER')")
      if [[ $INSERT_TEAM_W == "INSERT 0 1" ]]
       then
        echo inserted team,$WINNER
      fi
    fi
  fi

 TEAM_O=$($PSQL "select name from teams where name='$OPPONENT' ")
  if [[ $OPPONENT != "opponent" ]]
   then
    if [[ -z $TEAM_O ]]
      then
      INSERT_TEAM_O=$($PSQL "insert into teams(name) values('$OPPONENT')")
      if [[ $INSERT_TEAM_O == "INSERT 0 1" ]]
       then
        echo inserted team,$OPPONENT
      fi
    fi
  fi 

  TEAM_ID_W=$($PSQL "select team_id from teams where name='$WINNER' ")
  TEAM_ID_O=$($PSQL "select team_id from teams where name='$OPPONENT' ")
  if [[ -n $TEAM_ID_W || $TEAM_ID_O ]]
   then
    if [[ $YEAR != "year" ]]
     then
     INSERT_GAMES=$($PSQL "insert into games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) values($YEAR,'$ROUND',$TEAM_ID_W,$TEAM_ID_O,$WINNER_GOALS,$OPPONENT_GOALS)")
     if [[ $INSERT_GAMES == "INSERT 0 1" ]]
      then
      echo inserted game,$YEAR
     fi
    fi
  fi
done