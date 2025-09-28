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

dnf module disable redis -y &>> $LOG_FILE
VALIDATE $? "Disabling Redis default version"

dnf module enable redis:7 -y &>> $LOG_FILE
VALIDATE $? "Enabling redis version 7"

dnf install redis -y &>> $LOG_FILE
VALIDATE $? "Installing redis"

sed -i -e "s/127.0.0.1/0.0.0.0/g" -e "/protected-mode/c protected-mode no" /etc/redis/redis.conf 
VALIDATE $? "Giving remote access"

systemctl enable redis
VALIDATE $? "Enable redis"

systemctl start redis 
VALIDATE $? "Start Redis"

END_TIME=$(date +%s)
TOTAL_TIME=$(($END_TIME - $SCRIPT_TIME))

echo "Script executed in : $TOTAL_TIME"
