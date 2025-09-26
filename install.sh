#!/bin/bash

USER=$(id -u)
if [ $USER -ne 0 ]; then
    echo "ERROR: You donot have sudo permissions"
    exit 1
fi

dnf install nginx -y
if [ $? -ne 0 ]; then
    echo " Installation is failed"
else
    echo "Installation is successful"
fi

dnf install mysql -y
if [ $? -ne 0 ]; then
    echo " Installation is failed"
else
    echo "Installation is successful"
fi

dnf install python3 -y
if [ $? -ne 0 ]; then
    echo " Installation is failed"
else
    echo "Installation is successful"
fi