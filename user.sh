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
SCRIPT_TIME=$(date +%s)

mkdir -p $LOG_FOLDER

echo " Script started executing at : $(date)"\

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
VALIDATE $? "Disable nodejs "

dnf module enable nodejs:20 -y &>> $LOG_FILE
VALIDATE $? "Enable nodej version 20"

dnf install nodejs -y &>> $LOG_FILE
VALIDATE $? "Nodejs installation"

id=roboshop &>> $LOG_FILE
if [ $id -ne 0 ]; then
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>> $LOG_FILE
    VALIDATE $? "Setting up user"
else
    echo "User already exists"
fi

mkdir /app 
VALIDATE $? "Creating /app directory"

curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user-v3.zip  &>> $LOG_FILE
VALIDATE $? "downloading to tmp dir"

cd /app 
unzip /tmp/user.zip &>> $LOG_FILE
VALIDATE $? "Unzipping in /app"

npm install &>> $LOG_FILE
VALIDATE $? "Installing dependencies"

cp $SCRIPT_DIR/user.service /etc/systemd/system/user.service
VALIDATE $? "copy service file"

systemctl daemon-reload
VALIDATE $? "Daemon reload"

systemctl enable user  &>> $LOG_FILE
systemctl start user
VALIDATE $? "Enabling and starting user"

END_TIME=$(date +%s)
TOTAL_TIME=$(($END_TIME - $SCRIPT_TIME))

echo "Script executed in : $TOTAL_TIME"
