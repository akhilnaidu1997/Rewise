#!/bin/bash

R="\e[31m" #color codes for each color in shell script
G="\e[32m"
Y="\e[33m"
N="\e[0m"

echo  -e "\e[31m Hello world! I am learning DevSecOps with AWS $N" 
# Here -e enables the command after \ and $N represents no color(resetting color back to default color)
echo "Check the color"