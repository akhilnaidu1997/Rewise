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

cp $SCRIPT_DIR/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo
VALIDATE $? "Creating a local repo"

dnf install rabbitmq-server -y &>> $LOG_FILE
VALIDATE $? "Installing rabbit md"

systemctl enable rabbitmq-server &>> $LOG_FILE
VALIDATE $? "Enabling rabbitmq"

systemctl start rabbitmq-server
VALIDATE $? "Starting rabbit mq server"

rabbitmqctl add_user roboshop roboshop123 &>> $LOG_FILE
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> $LOG_FILE
VALIDATE $? "Setting up rabbitmq user"

END_TIME=$(date +%s)
TOTAL_TIME=$(($END_TIME - $SCRIPT_TIME))

echo "Script executed in : $TOTAL_TIME"


