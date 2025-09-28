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


dnf install python3 gcc python3-devel -y &>> $LOG_FILE
VALIDATE $? "Installing python"

id=roboshop &>> $LOG_FILE
if [ $? -ne 0 ]; then
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>> $LOG_FILE
    VALIDATE $? "Setting up user"
else
    echo " User already exists"
fi

mkdir -p /app
VALIDATE $? "creating a dir"

curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment-v3.zip  &>> $LOG_FILE
VALIDATE $? "Downloading into temp dir"

cd /app 

rm -rf /app/* &>> $LOG_FILE
VALIDATE $? "Deleting the existing code"

unzip /tmp/payment.zip  &>> $LOG_FILE
VALIDATE $? "Unzipping into /app"

pip3 install -r requirements.txt &>> $LOG_FILE
VALIDATE $? "Installing  dependencies"

cp $SCRIPT_DIR/payment.service  /etc/systemd/system/payment.service
VALIDATE $? "Copying service file"

systemctl daemon-reload
systemctl enable payment &>> $LOG_FILE
systemctl start payment

VALIDATE $? "Enable, start and reload app"