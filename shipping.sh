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
mysql="mysql.daws86s-akhil.shop"

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

dnf install maven -y &>> $LOG_FILE
VALIDATE $? "Installing maven and java"

id=roboshop &>> $LOG_FILE
if [ $? -ne 0 ]; then
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>> $LOG_FILE
    VALIDATE $? "Setting up user"
else
    echo " User already exists"
fi

mkdir -p /app 
VALIDATE $? "Creating /app directory"

curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping-v3.zip  &>> $LOG_FILE
VALIDATE $? "downloading to tmp dir"

cd /app 
VALIDATE $? "Changing the directory"

rm -rf /app/*
VALIDATE $? "Deleting the existing code"

unzip /tmp/shipping.zip &>> $LOG_FILE
VALIDATE $? " Unzipping in /app"

mvn clean package &>> $LOG_FILE
VALIDATE $? "Building the package"

mv target/shipping-1.0.jar shipping.jar 
VALIDATE $? "Copying the package into /app"

cp $SCRIPT_DIR/shippping.service /etc/systemd/system/shipping.service

systemctl daemon-reload

systemctl enable shipping &>> $LOG_FILE
VALIDATE $? "Enabling and starting the app"

dnf install mysql -y  &>> $LOG_FILE
VALIDATE $? "Installing mysql"

mysql -h $mysql -uroot -pRoboShop@1 < /app/db/schema.sql &>> $LOG_FILE
VALIDATE $? "Loading schema"

mysql -h $mysql -uroot -pRoboShop@1 < /app/db/app-user.sql &>> $LOG_FILE
VALIDATE $? "app-user"
mysql -h $mysql -uroot -pRoboShop@1 < /app/db/master-data.sql &>> $LOG_FILE
VALIDATE $? "Loading schema"
systemctl restart shipping
VALIDATE $? "restarting the service"

