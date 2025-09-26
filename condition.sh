#!/bin/bash

NUM=$1

if [ $NUM -lt 10 ]; then
    echo "Given number $NUM is less than 10"
else
    echo "Given number $NUM is greater than or equal to 10"
fi