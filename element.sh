
#!/bin/bash

# PostgreSQL connection
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Check if an argument was provided
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

# Query the database
ELEMENT=$($PSQL "
SELECT e.atomic_number, e.name, e.symbol,
       p.atomic_mass, p.melting_point_celsius,
       p.boiling_point_celsius, t.type
FROM elements e
JOIN properties p USING(atomic_number)
JOIN types t USING(type_id)
WHERE e.atomic_number::TEXT = '$1'
   OR e.symbol = '$1'
   OR e.name = '$1';
")

# Check if element exists
if [[ -z $ELEMENT ]]
then
  echo "I could not find that element in the database."
else
  # Extract values
  echo "$ELEMENT" | while IFS='|' read -r ATOMIC_NUMBER NAME SYMBOL MASS MELTING BOILING TYPE
  do
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
  done
fi
