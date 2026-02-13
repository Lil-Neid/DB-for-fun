#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"


echo -e "\n~~~~~ MY SALON ~~~~~"

echo -e"\nWelcome to My Salon, how can I help you?"

MAIN_MENU(){
  if [[ $1 ]]
  then 
    echo -e "\n$1"
  
  fi
  SERVICE=$($PSQL "select service_id, name from services service_id;")

  echo "$SERVICE" | while read service_id BAR name
  do
    echo "$service_id) $name"
  done 

  read SERVICE_ID_SELECTED

  SERVICE_NAME=$($PSQL "select name from services where service_id = $SERVICE_ID_SELECTED ;")

  if [[ -z $SERVICE_NAME ]]
  then 
    MAIN_MENU "I could not find that service. What would you like today?"
  else 
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE

  
  CUSTOMER_NAME=$($PSQL "select name from customers where phone = '$CUSTOMER_PHONE';")

    if [[ -z $CUSTOMER_NAME ]]
      then
        echo -e "\nI don't have a record for that phone number, what's your name?"
        read CUSTOMER_NAME
        INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE');")
    
    fi
  
  CUSTOMER_ID=$($PSQL "select customer_id from customers where phone ='$CUSTOMER_PHONE';")

  echo -e "\nWhat time would you like your$SERVICE_NAME, $CUSTOMER_NAME?"
  read SERVICE_TIME

  INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME');")

  echo -e "\nI have put you down for a$SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
  
  fi

}

MAIN_MENU
