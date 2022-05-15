#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
#delete all data into the tables
$PSQL "TRUNCATE TABLE games, teams;"
INSERTED=0

#read and insert data
cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != year ]]
  then
    #get current winner team
    WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")"
    #if not found
    if [[ -z $WINNER_ID ]]
    then
      INSERT_TEAM="$($PSQL "INSERT INTO teams (name) VALUES ('$WINNER')")"
      if [[ $INSERT_TEAM == "INSERT 0 1" ]]
      then
        echo INSERTED $WINNER INTO TEAMS
      fi
      #get new winner ID
      WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")"
    fi

    #get current opponent team
    OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")"
    #if not found
    if [[ -z $OPPONENT_ID ]]
    then
      INSERT_TEAM="$($PSQL "INSERT INTO teams (name) VALUES ('$OPPONENT')")"
      if [[ $INSERT_TEAM == "INSERT 0 1" ]]
      then
        echo INSERTED $OPPONENT INTO TEAMS
      fi
      #get new winner ID
      OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")"
    fi

    #insert a game
    INSERT_GAME="$($PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")"
    echo INSERTED $(( INSERTED += 1 )) INTO games
  fi 
done
echo FINISHED