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

echo " Script started executing at : $(date)"

if [ $USER -ne 0 ]; then
    echo -e "Please proceed with $R sudo permissions $N"
    exit 1
fi

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo -e "$2 $R failed $N"
        exit 1
    else
        echo -e " $2 is  $Y Successful $N" | tee -a $LOG_FILE
fi
}

cp mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "Adding repo"

dnf list installed mongodb-org
VALIDATE $? "Installing mongodb"

systemctl enable mongod 
systemctl start mongod 
VALIDATE $? "Starting mongodb"

sed -i "s/127.0.0.1/0.0.0.0/g" /etc/mongod.conf
VALIDATE $? "Giving remote access for mongodb"

systemctl restart mongod
VALIDATE $? "Restarted mongodb"

