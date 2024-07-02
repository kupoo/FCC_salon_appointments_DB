#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --no-align --tuples-only -c"



echo -e "\n~~~~ My Salon ~~~~"

MAIN_MENU()
{
  if [[ $1 ]]
  then
    echo -e "\n$1"
  else
    echo "Mithraaks welcomes you. What can this humble servant of the Styler do for you today?"
  fi

  #populate array with all service ids from database
  SERVICE_ID_ARRAY=($($PSQL "select service_id from services"))
  
  #show menu options with dynamic service id and name querying 
  for (( i = 0; i < ${#SERVICE_ID_ARRAY[@]}; i++ ))
  do
    SERVICE_NAME=$($PSQL "select name from services where service_id = ${SERVICE_ID_ARRAY[i]}")
    echo -e "${SERVICE_ID_ARRAY[i]}) $SERVICE_NAME"
  done

  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
    1) CUT_MENU;;
    2) COLOR_MENU;;
    3) STYLE_MENU;;
    *) MAIN_MENU "I am sorry, that service is not available. Please, pick another.";;
  esac
}

CREATE_APPOINTMENT()
{
  echo -e "\nOf course. Please enter your mobile communications device number into the splicer terminal."
  
  if [[ $1 ]] 
  then
    SERVICE_NAME=$1
  fi
  
  #get customer phone number
  read CUSTOMER_PHONE

  #check if a customer exists with that phone number
  CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_ID ]]
  then
    echo -e "\nThere are no matching entries for that number in my database. What is your name?"
    
    #get customer name
    read CUSTOMER_NAME

    #insert customer info
    INSERT_CUSTOMER_INFORMATION=$($PSQL "insert into customers(phone, name) values('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
  else
    CUSTOMER_NAME=$($PSQL "select name from customers where phone='$CUSTOMER_PHONE'")
  fi

  CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")
  
  echo "What time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
  read SERVICE_TIME

  echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."

  #insert appointment
  INSERT_APPOINTMENT=$($PSQL "insert into appointments(customer_id, service_id, time) values($CUSTOMER_ID, '$SERVICE_ID_SELECTED', '$SERVICE_TIME')")

}

CUT_MENU()
{
  CREATE_APPOINTMENT cut
}

COLOR_MENU()
{
  CREATE_APPOINTMENT color
}

STYLE_MENU()
{
  CREATE_APPOINTMENT style
}

MAIN_MENU



