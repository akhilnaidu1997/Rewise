#!/bin/bash

USER=$(id -u)

if [ $USER -ne 0 ]; then
    echo "ERROR:: Please proceed with sudo permissions"
    exit 1
fi

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo "Installation of $2 failed"
    else
        echo " $2 is already installed"
fi
}

dnf install mysql -y
VALIDATE $? "MYSQL"

dnf install nginx -y
VALIDATE $? "NGINX"

dnf install python3 -y
VALIDATE $? "PYTHON"