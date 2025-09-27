#!/bin/bash


USER=$(id -u)
if [ $USER -ne 0 ]; then
    echo "$R Please proceed with sudo permissions $N"
    exit 1
fi

dnf install mysql -y

if [ $? -ne 0 ]; then
    echo " Installation of mysql is $R FAILED $N"
else
    echo " Installation of mysql is $G SUCCESSFUL $N"
fi

dnf install nginx -y

if [ $? -ne 0 ]; then
    echo " Installation of nginx is $R FAILED $N"
else
    echo " Installation of nginx is $G SUCCESSFUL $N"
fi

dnf install python3 -y

if [ $? -ne 0 ]; then
    echo " Installation of python is $R FAILED $N"
else
    echo " Installation of python is $G SUCCESSFUL $N"
fi
