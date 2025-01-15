#!/bin/bash

LOGS_FOLDER="/var/log/shell-script"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME-$TIMESTAMP.log"
sudo mkdir -p /var/log/shell-script

Userid=$(id -u)
  echo "User id is: $Userid"

  R="\e[31m"
  G="\e[32m"
  Y="\e[33m"
  N="\e[0m"

CHECK_ROOT(){
    if [ $Userid -ne 0 ]
    then
       echo -e "$R Please login with root previleges $N" &>>$LOG_FILE
       exit 1
    fi   
}

VALIDATE(){
    if [ $1 -ne 0 ]
    then
       echo  -e "$2 is.. $R Failed $N" &>>$LOG_FILE
       exit 1
    else
       echo -e "$2 is.. $G Success $N" &>>$LOG_FILE
    fi       
}

USAGE(){
     echo -e "$R USAGE: $N sudo sh script-ex13.sh package1 package2.."
     exit 1
}

CHECK_ROOT

if [ $# -eq 0 ]
then
    USAGE
fi    

for package in $@
do
   dnf list installed $package &>>$LOG_FILE
   if [ $? -ne 0 ]
   then
      echo "$package is not installed.. going to install" &>>$LOG_FILE
      dnf install $package -y &>>$LOG_FILE
      VALIDATE $? "Installing $package"
    else
      echo -e "$package is $Y already installed.. Nothing to do $N" &>>$LOG_FILE
    fi
done