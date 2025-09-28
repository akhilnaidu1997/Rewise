#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

USER=$(id -u)

LOG_FOLDER="/var/log/shell-practice"
SCRIPT_NAME=$( echo $0 | cut -d "." -f1 )
LOG_FILE="$LOG_FOLDER/$SCRIPT_NAME.log"

mkdir -p $LOG_FOLDER

echo " Scriptb started executing at : $(date)"

if [ $USER -ne 0 ]; then
    echo -e "Please proceed with $R sudo permissions $N"
    exit 1
fi

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo -e "Installation of $2 $R failed $N"
    else
        echo -e " $2 is  $Y Successful $N" | tee -a $LOG_FILE
fi
}

for PACKAGE in $@
do
    dnf list installed $PACKAGE &>> $LOG_FILE 
    if [ $? -ne 0 ]; then
        dnf install $PACKAGE -y &>> $LOG_FILE 
        VALIDATE $? "$PACKAGE"
    else
        echo -e "$PACKAGE already $Y installed $N" | tee -a $LOG_FILE
    fi
done
