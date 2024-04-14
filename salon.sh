#!/bin/bash

# Set $PSQL variable for connecting to the database.
PSQL="psql -U freecodecamp -d salon -q -A -t -c"

SERVICES=$($PSQL "SELECT service_id, name FROM services")

SHOW_SERVICES() {
  while IFS="|" read ID SERVICE
  do
    echo "$ID) $SERVICE"
  done <<< "$1"
}

GET_SERVICE() {
  while [[ ! $CHOSEN ]]
  do
    SHOW_SERVICES "$SERVICES"
    echo "Which service would you like?"
    read  SERVICE_ID_SELECTED
    
      if [[ $SERVICE_ID_SELECTED =~ [^1-3] ]]
      then
        echo "$SERVICE_ID_SELECTED is not a valid choice!"
        continue
      fi
    CHOSEN=$($PSQL "SELECT service_id, name FROM services WHERE service_id = '$SERVICE_ID_SELECTED'")
  done
}

GET_INFO() {
  IS_CUSTOMER=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$1'")
  if [[ ! $IS_CUSTOMER ]]
  then
  echo "Please enter your name:"
    read CUSTOMER_NAME
    INS_CUSTOMER_INFO=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
  fi
  echo "What time would you like your appointment?"
  read SERVICE_TIME
}

GET_SERVICE
#echo "You chose:" 
#SHOW_SERVICES "$CHOSEN"

echo "Please enter your phone number:"
read CUSTOMER_PHONE

GET_INFO $CUSTOMER_PHONE

CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE name = '$CUSTOMER_NAME'")
SET_APPT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES('$CUSTOMER_ID', '$SERVICE_ID_SELECTED', '$SERVICE_TIME')")
SERVICE=$($PSQL "SELECT name FROM services WHERE service_id = '$SERVICE_ID_SELECTED'")

echo "I have put you down for a $SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."
