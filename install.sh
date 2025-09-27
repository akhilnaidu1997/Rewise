#!/bin/bash


USER=$(id -u)
if [ $USER -ne 0 ]; then
    echo "$R Please proceed with sudo permissions $N"
    exit 1
fi

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo " Installation of $2 is $R FAILED $N"
    else
        echo " Installation of $2 is $G SUCCESSFUL $N"
    fi

}

dnf install mysql -y
VALIDATE $? "mysql"

dnf install nginx -y
VALIDATE $? "nginx"

dnf install python3 -y
VALIDATE $? "python"
