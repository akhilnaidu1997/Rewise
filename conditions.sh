#!/bin/bash

R="\e[31m" #color codes for each color in shell script
G="\e[32m"
Y="\e[33m"
N="\e[0m"

USER=$(id -u)
if [ $USER -ne 0 ]; then
    echo -e "$Ryou donot have sudo permissions to install$N"
    exit 1
fi

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo -e "ERROR:: Installation of $2 is $R failed $N"
    else
        echo -e "Installation of $2 is $G successful $N"
fi
}

dnf list installed mysql 
if [ $? -ne 0 ]; then
    dnf install mysql -y
    VALIDATE $? "mysql" 
else
    echo " Mysql is already installed ... $Y Skipping $N"
fi

dnf list installed nginx 
if [ $? -ne 0 ]; then
    dnf install nginx -y
    VALIDATE $? "nginx"
else
    echo "nginx is already installed ... $Y Skipping $N"
fi

dnf list installed python3
if [ $? -ne 0 ]; then
    dnf install python3 -y
    VALIDATE $? "python3" 
else
    echo "Python3 is already installed ...$Y Skipping $N"
fi

