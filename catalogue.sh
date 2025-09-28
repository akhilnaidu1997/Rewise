#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

USER=$(id -u)

LOG_FOLDER="/var/log/shell-practice"
SCRIPT_NAME=$( echo $0 | cut -d "." -f1 )
LOG_FILE="$LOG_FOLDER/$SCRIPT_NAME.log"
MONGOHOST="mongodb.daws86s-akhil.shop"
SCRIPT_DIR=$PWD 

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

dnf module disable nodejs -y &>> $LOG_FILE
VALIDATE $? "Disable default version of nodejs"

dnf module enable nodejs:20 -y &>> $LOG_FILE
VALIDATE $? "Enable version 20"

dnf install nodejs -y &>> $LOG_FILE
VALIDATE $? "Installing Nodejs"

id roboshop &>> $LOG_FILE
if [ $? -ne 0 ]; then
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>> $LOG_FILE
    VALIDATE $? "Adding user"
else
    echo "User already exists" 
fi

mkdir -p /app
VALIDATE $? "Creating a directory"

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip &>> $LOG_FILE
VALIDATE $? "downloading into temp directory"

cd /app
VALIDATE $? "cd into /app"

rm -rf /app/*
VALIDATE $? "Removing exisiting code"

unzip /tmp/catalogue.zip &>> $LOG_FILE
VALIDATE $? "Unzip into /app"

npm install &>> $LOG_FILE
VALIDATE $? "Installing dependencies"

cp $SCRIPT_DIR/catalogue.service /etc/systemd/system/catalogue.service
VALIDATE $? "Copying service file into systemd dir"

systemctl daemon-reload
VALIDATE $? " Daemon reload"

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "Copy repo file into local repos"

dnf install mongodb-mongosh -y &>> $LOG_FILE
VALIDATE $? "Installing mongodb client"

INDEX=$(mongosh mongodb.daws86s-akhil.shop --quiet --eval "db.getMongo().getDBNames().indexOf('catalogue')")
if [ $INDEX -lt 0 ]; then
    mongosh --host $MONGOHOST </app/db/master-data.js &>> $LOG_FILE
    VALIDATE $? "Connecting to mongodb and loading schema"
else
    echo "collections already exists"
fi
systemctl restart catalogue
VALIDATE $? "Restart service"
