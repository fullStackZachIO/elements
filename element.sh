#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

ELEMENT_INFO() {
  #Check for arguments
  if [[ -z $1 ]]
  then
    echo -e "Please provide an element as an argument."
  else
    FIND_MATCH $1
  fi
}

FIND_MATCH() {
  if [[ $1 =~ ^[1-9]$|^10$ ]]
  then
    SELECT_ATOMIC_NUMBER_RESULT=$($PSQL "select name from elements where atomic_number = $1")
    if [[ -z $SELECT_ATOMIC_NUMBER_RESULT ]]
    then
      echo "I could not find that element in the database."
    else
      GET_INFO $SELECT_ATOMIC_NUMBER_RESULT
    fi
  elif [[ $1 =~ ^[A-Za-z]{1,2}$ ]]
  then
    SELECT_SYMBOL_RESULT=$($PSQL "select name from elements where symbol ilike '$1'")
    if [[ -z $SELECT_SYMBOL_RESULT ]]
    then
      echo "I could not find that element in the database."
    else
      GET_INFO $SELECT_SYMBOL_RESULT
    fi
  elif [[ $1 =~ ^[A-Za-z]{3,}$ ]]
  then
    SELECT_NAME_RESULT=$($PSQL "select name from elements where name ilike '$1'")
    if [[ -z $SELECT_NAME_RESULT ]]
    then
      echo "I could not find that element in the database."
    else
      GET_INFO $SELECT_NAME_RESULT
    fi
  else
    echo -e "I could not find that element in the database."
  fi
  
}

GET_INFO() {
  INFO_RESULT=$($PSQL "select * from elements inner join properties using(atomic_number) inner join types using(type_id) where name = '$1'")
  echo $INFO_RESULT | while IFS="|" read TYPE_ID ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE
  do
    echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  done
}

ELEMENT_INFO $1
