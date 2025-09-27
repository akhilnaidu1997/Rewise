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

dnf list installed mysql
if [ $? -ne 0 ]; then
    dnf install mysql -y
    VALIDATE $? "mysql"
else
    echo "mysql is already installed"
fi

dnf list installed nginx
if [ $? -ne 0 ]; then
    dnf install nginx -y
    VALIDATE $? "nginx"
else
    echo "nginx is already installed"
fi

dnf list installed python
if [ $? -ne 0 ]; then
    dnf install python3 -y
    VALIDATE $? "python"
else
    echo "python is already installed"
fi
