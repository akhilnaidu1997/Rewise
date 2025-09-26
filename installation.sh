#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

USER=$(id -u)

LOG_FOLDER="/var/log/shell-practice"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOG_FOLDER/$SCRIPT_NAME.log"

mkdir -p $LOG_FOLDER

if [ $USER -ne 0 ]; then
    echo -e "Please proceed with $R sudo permissions $N"
    exit 1
fi

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo -e "Installation of $2 $R failed $N"
    else
        echo -e " $2 is already $Y installed $N"
fi
}


dnf list installed mysql &>>LOG_FILE
if [ $? -ne 0 ]; then
    dnf install mysql -y &>>LOG_FILE
    VALIDATE $? "MYSQL"
else
    echo -e "MYSQL already $Y installed $N"
fi

dnf list installed nginx &>>LOG_FILE
if [ $? -ne 0 ]; then
    dnf install nginx -y &>>LOG_FILE
    VALIDATE $? "NGINX"
else
    echo -e "NGINX already $Y installed $N"
fi

dnf list installed python3 &>>LOG_FILE
if [ $? -ne 0 ]; then
    dnf install python3 -y &>>LOG_FILE
    VALIDATE $? "PYTHON"
else
    echo -e "PYTHON already $Y installed $N"
fi