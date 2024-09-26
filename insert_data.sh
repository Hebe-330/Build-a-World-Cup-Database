
#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# $PSQL "TRUNCATE teams,games"


# Do not change code above this line. Use the PSQL variable above to query your database.
# Function to insert teams
function insert_teams() {
  tail -n +2 games.csv | while IFS=, read -r year round winner opponent winner_goals opponent_goals; do
    # Insert winner team if not exists
    $PSQL "INSERT INTO teams (name) VALUES ('$winner') ON CONFLICT (name) DO NOTHING"

    # Insert opponent team if not exists
    $PSQL "INSERT INTO teams (name) VALUES ('$opponent') ON CONFLICT (name) DO NOTHING"
  done
}

insert_teams


# Function to insert games
function insert_games() {
  tail -n +2 games.csv | while IFS=, read -r year round winner opponent winner_goals opponent_goals; do
    winner_id=$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")
    opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent'")
    $PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($year, '$round', $winner_id, $opponent_id, $winner_goals, $opponent_goals)"
  done
}


insert_games



