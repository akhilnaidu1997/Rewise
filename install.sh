#!/bin/bash

USER=$(id -u)
if [ $USER -ne 0 ]; then
    echo "ERROR: You donot have sudo permissions"
    exit 1
fi

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo " Installation of $2 is failed"
    else
        echo "Installation  of $2 is successful"
fi
}

dnf install nginx -y
VALIDATE $? "nginx"

dnf install mysql -y
VALIDATE $? "mysql"

dnf install python3 -y
VALIDATE $? "Python3"

