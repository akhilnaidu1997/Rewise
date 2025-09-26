#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

USER=$(id -u)

if [ $USER -ne 0 ]; then
    echo -e "Please proceed with $R sudo permissions $N"
    exit 1
fi

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo -e "Installation of $2 $R failed $N"
    else
        echo -e " $2 is already $Y installed $N"
fi
}


dnf list installed mysql
if [ $? -ne 0 ]; then
    dnf install mysql -y
    VALIDATE $? "MYSQL"
else
    echo -e "MYSQL already $Y installed $N"
fi

dnf list installed nginx
if [ $? -ne 0 ]; then
    dnf install nginx -y
    VALIDATE $? "NGINX"
else
    echo -e "NGINX already $Y installed $N"
fi

dnf list installed python3
if [ $? -ne 0 ]; then
    dnf install python3 -y
    VALIDATE $? "PYTHON"
else
    echo -e "PYTHON already $Y installed $N"
fi