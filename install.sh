#!/bin/bash

USER=$(id -u)

if [ $USER -ne 0 ]; then
    echo " ERROR:: You donot have sudo permissions, please proceed with sudo access"
    exit 1
fi

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo " ERROR: Installation of $2 is failed"
    else
        echo "$2 Installation is successful"
    fi
}

dnf install nginx -y
VALIDATE $? "NGINX"
