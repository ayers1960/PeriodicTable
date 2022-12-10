#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"
## CUSTOMER_NAME=$($PSQL "SELECT *  FROM properties" )
## echo $CUSTOMER_NAME
ARGC=$#
if [[ $ARGC -ne 1 ]] 
then
   echo "Please provide an element as an argument."
   exit
else
   value=$1
fi
if [[ $value =~ ^-?[0-9]+$ ]] 
then
	Q="E.atomic_number = '$value'"
else
	Q="E.symbol = '$value' OR E.name = '$value'"
fi
INFO=$($PSQL "SELECT E.atomic_number, E.symbol, E.name ,
                     P.atomic_mass, P.melting_point_celsius, P.boiling_point_celsius,
		     T.type
              FROM elements AS E
	           LEFT JOIN properties AS P ON (E.atomic_number = P.atomic_number)
	           LEFT JOIN types  AS T ON (P.type_id = T.type_id)
	      WHERE $Q " )
if [[ -n $INFO ]]
then
	while read ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR MASS BAR MELTING BAR BOILING BAR TYPE 
	do
	##	echo -n "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). "
	##	echo -n "It's a $TYPE, with a mass of $MASS amu.  ";
	##	echo -n "$NAME has a melting point of $MELTING and a boiling point of $BOILING celsius."
	##	echo 
	echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
	done < <(echo $INFO)
else
	echo "I could not find that element in the database."
fi
