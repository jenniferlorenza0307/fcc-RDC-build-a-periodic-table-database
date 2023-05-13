#! /bin/bash

# initial psql command
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# check if no argument is provided
if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."
  exit 0
fi

# check the argument with regex pattern
# digit pattern
if [[ $1 =~ ^[0-9]+$ ]]; then
  # query by atomic_number
  QUERY_RESULT=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE atomic_number="$1";")

# varchar(2) pattern
elif [[ $1 =~ ^[A-Za-z]{1,2}$ ]]; then
  # query by symbol
  QUERY_RESULT=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE symbol='$1';")

# other pattern assumed as name
else 
  # query by name
  QUERY_RESULT=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE name='$1';")
fi

# if result is empty
if [[ -z $QUERY_RESULT ]]; then
  echo "I could not find that element in the database."
  exit 0
fi

# query for other properties
echo "$QUERY_RESULT" | while IFS='|' read ATOMIC_NUMBER SYMBOL NAME TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT
do 
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
done