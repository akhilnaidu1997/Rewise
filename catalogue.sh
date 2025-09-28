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

mkdir /app
VALIDATE $? "Creating a directory"

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip 
VALIDATE $? "downloading into temp directory"

cd /app
VALIDATE $? "cd into /app"

unzip /tmp/catalogue.zip
VALIDATE $? "Unzip into /app"

npm install &>> $LOG_FILE
VALIDATE $? "Installing dependencies"

cp /home/ec2-user/Rewise/catalogue.service /etc/systemd/system/catalogue.service
VALIDATE $? "Copying service file into systemd dir"

systemctl daemon-reload
VALIDATE $? " Daemon reload"

cp /home/ec-user/Rewise/mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "Copy repo file into local repos"

dnf install mongodb-mongosh -y &>> $LOG_FILE
VALIDATE $? "Installing mongodb client"

mongosh --host mongodb.daws86s-akhil.shop </app/db/master-data.js
VALIDATE $? "Connecting to mongodb and loading schema"


