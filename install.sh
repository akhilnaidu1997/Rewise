#!/bin/bash

USER=$(id -u)

if [ $USER -ne 0 ]; then
    echo " ERROR:: You donot have sudo permissions, please proceed with sudo access"
    exit 1
fi

dnf install nginx -y
if [ $? -ne 0 ]; then
    echo " ERROR: Installation is failed"
else
    echo "Installation is successful"
fi
