#!/bin/bash

USER=$(id -u)
if [ $USER -ne 0 ]; then
    echo "ERROR: you donot have sudo permissions to install"
    exit 1
fi

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo "ERROR:: Installation of $2 is failed"
    else
        echo "Installation of $2 is successful"
fi
}

dnf list installed mysql 
if [ $? -ne 0 ]; then
    dnf install mysql -y
    VALIDATE $? "mysql" 
else
    echo " Mysql is already installed ... Skipping"
fi

dnf list installed nginx 
if [ $? -ne 0 ]; then
    dnf install nginx -y
    VALIDATE $? "nginx"
else
    echo "nginx is already installed ... Skipping"
fi

dnf list installed python3
if [ $? -ne 0 ]; then
    dnf install python3 -y
    VALIDATE $? "python3" 
else
    echo "Python3 is already installed ... Skipping"
fi

