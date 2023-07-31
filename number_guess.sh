#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=number_guess --tuples-only -c"
RAND=$(($RANDOM % 1000 + 1))
TRIES=0
GAME() {

	read GUESS
	if [[ ! $GUESS =~ ^[0-9]+$ ]]
	then
		echo "That is not an integer, guess again:"
		GAME
	else
		if [[ $GUESS -gt $RAND ]]
		then
			echo "It's lower than that, guess again:"
			TRIES=$((TRIES + 1))
			GAME
		
		else 
      if [[ $RAND -gt $GUESS ]]
		  then
			  echo "It's higher than that, guess again:"
			  TRIES=$((TRIES + 1))
			  GAME
		  else
        TRIES=$((TRIES + 1))
			  echo "You guessed it in $TRIES tries. The secret number was $RAND. Nice job!"
			  UPDATE_BEST=$($PSQL "UPDATE users SET games_played=$((GAMES_PLAYED + 1)) WHERE username='$NAME'")
			  if [[ $BEST_GAME -gt $TRIES || $BEST_GAME -eq 0 ]]
		  	then
			  	UPDATE_GUESS=$($PSQL "UPDATE users SET best_game= $TRIES WHERE username='$NAME'")
			  fi
		  fi
    fi
	fi
}
echo "Enter your username:"
read NAME
USERNAME=$($PSQL "SELECT username FROM users WHERE username='$NAME'")
if [[ -z $USERNAME ]]
then
	echo "Welcome, $NAME! It looks like this is your first time here."
	INSERT_DATA=$($PSQL "INSERT INTO users(username, games_played, best_game) VALUES('$NAME',0,0)")
	echo "Guess the secret number between 1 and 1000:"
	GAME
else
	GAMES_PLAYED=$($PSQL "SELECT games_played FROM users WHERE username='$NAME'")
  BEST_GAME=$($PSQL "SELECT best_game FROM users WHERE username='$NAME'")
	echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  

	echo "Guess the secret number between 1 and 1000:"
	GAME
fi

