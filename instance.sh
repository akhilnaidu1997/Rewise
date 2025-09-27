#!/bin/bash

INSTANCE_ID=$( aws ec2 run-instances --image-id ami-09c813fb71547fc4f --count 1 --instance-type t3.micro --security-group-ids sg-0fee42dfd5533e5de --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=TEST}]" )

if [ $INSTANCE_ID -ne "frontend" ]; then
    IP=$(aws ec2 describe-instances --instance-ids i-0eca56180912f7295 --query "Reservations[0].Instances[0].PrivateIpAddress" --output text)
else
    IP=$(aws ec2 describe-instances --instance-ids i-0eca56180912f7295 --query "Reservations[0].Instances[0].PublicIpAddress" --output text)
fi

aws route53 change-resource-record-sets \
  --hosted-zone-id Z10111863267OBDLA0XLE \
  --change-batch '
  {
    "Comment": "Updating record set"
    ,"Changes": [{
      "Action"              : "UPSERT"
      ,"ResourceRecordSet"  : {
        "Name"              : "'mongodb.daws86s-akhil.shop'"
        ,"Type"             : "A"
        ,"TTL"              : 1
        ,"ResourceRecords"  : [{
            "Value"         : "'$IP'"
        }]
      }
    }]
  }
  '

