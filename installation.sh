#!/bin/bash

USER=$(id -u)

if [ $USER -ne 0 ]; then
    echo "ERROR:: Please proceed with sudo permissions"
    exit 1
fi

dnf install mysql -y

if [ $? -ne 0 ]; then
    echo "Installation of mysql failed"
else
    echo " MYSQL is already installed"
fi

dnf install nginx -y

if [ $? -ne 0 ]; then
    echo "Installation of nginx failed"
else
    echo " nginx is already installed"
fi

dnf install python3 -y

if [ $? -ne 0 ]; then
    echo "Installation of python failed"
else
    echo " python is already installed"
fi