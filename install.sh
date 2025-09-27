#!/bin/bash


USER=$(id -u)
if [ $USER -ne 0 ]; then
    echo "$R Please proceed with sudo permissions $N"
    exit 1
fi

LOG_FOLDER="/var/log/shellshell"
SCRIPT_NAME=$( echo $0 | cut -d "." -f1 )
LOG_FILE="$LOG_FOLDER/$SCRIPT_NAME.log"

mkdir -p $LOG_FOLDER 

echo "Script started at : $(date)"

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo " Installation of $2 is $R FAILED $N"
    else
        echo " Installation of $2 is $G SUCCESSFUL $N"
    fi

}

dnf list installed mysql $>> $LOG_FILE 
if [ $? -ne 0 ]; then
    dnf install mysql -y $>> $LOG_FILE
    VALIDATE $? "mysql"
else
    echo "mysql is already installed"
fi

dnf list installed nginx $>> $LOG_FILE
if [ $? -ne 0 ]; then
    dnf install nginx -y $>> $LOG_FILE
    VALIDATE $? "nginx"
else
    echo "nginx is already installed"
fi

dnf list installed python3 $>> $LOG_FILE
if [ $? -ne 0 ]; then
    dnf install python3 -y $>> $LOG_FILE
    VALIDATE $? "python"
else
    echo "python is already installed"
fi
