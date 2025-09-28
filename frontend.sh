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

dnf module disable nginx -y &>> $LOG_FILE
VALIDATE $? "Disable nginx"

dnf module enable nginx:1.24 -y &>> $LOG_FILE
VALIDATE $? "Enable nginx 1.24"

dnf install nginx -y &>> $LOG_FILE
VALIDATE $? "Install nginx"

systemctl enable nginx  &>> $LOG_FILE
VALIDATE $? "Enable nginx"

systemctl start nginx 
VALIDATE $? "Start nginx"

rm -rf /usr/share/nginx/html/*  &>> $LOG_FILE
VALIDATE $? " Remove the exisiting code"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>> $LOG_FILE
VALIDATE $? "Downaloding to temp dir"

cd /usr/share/nginx/html 
unzip /tmp/frontend.zip &>> $LOG_FILE
VALIDATE $? "Unzipping files"

cp $SCRIPT_DIR/nginx.conf  /etc/nginx/nginx.conf
VALIDATE $? " Copy conf file"

systemctl restart nginx 
VALIDATE $? "Restart nginx"

