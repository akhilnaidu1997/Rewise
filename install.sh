#!/bin/bash

USER=$(id -u)
if [ $USER -ne 0 ]; then
    echo "$R Please proceed with sudo permissions $N"
fi

dnf install mysql -y

if [ $? -ne 0 ]; then
    echo " Installation of mysql is $R FAILED $N"
else
    echo " Installation of mysql is $G SUCCESSFUL $N"
fi

