#!/bin/bash

USER=$(id -u)
if [ $USER -ne 0 ]; then
    echo "ERROR: you donot have sudo permissions to install"
    exit 1
fi

VALIDATE(){
    if [ $? -ne 0 ]; then
        echo "ERROR:: Installation of mysql is failed"
    else
        echo "Installation of mysql is successful"
fi
}

dnf install mysql -y
VALIDATE 


