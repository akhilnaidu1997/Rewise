#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

USER=$(id -u)
if [ $USER -ne 0 ]; then
    echo -e "$R Please proceed with sudo permissions $N"
    exit 1
fi

LOG_FOLDER="/var/log/shellshell"
SCRIPT_NAME=$( echo $0 | cut -d "." -f1 )
LOG_FILE="$LOG_FOLDER/$SCRIPT_NAME.log"

mkdir -p $LOG_FOLDER 

echo "Script started at : $(date)"

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo  -e " Installation of $2 is $R FAILED $N"
    else
        echo -e " Installation of $2 is $G SUCCESSFUL $N"
    fi

}

for PACKAGE in $@
do
    dnf list installed $1 &>> $LOG_FILE 
    if [ $? -ne 0 ]; then
        dnf install $1 -y &>> $LOG_FILE
        VALIDATE $? "$1"
        exit 1
    else
        echo -e "$1 is already $Y installed $N"
    fi

done
