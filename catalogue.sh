#!/bin/bash

source ./common.sh

app_name=catalogue

check_root
app_setup
nodejs_setup
systemd_setup

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo
dnf install mongodb-mongosh -y &>>LOGS_FILE
VALIDATE $? "Installing Mongodb clinet"

STATUS=$(mongosh --host mongodb.malli.site --eval 'db.getMongo().gitDBNames().indexof( "catalogue")')
if[ $STATUS -lt 0 ]
then 
    mongosh --host mongodb.malli.site </app/db/master-date.js &>>LOG_FILE
    VALIDATE $? "Loading data into MongoDB"
else
    echo -e "Data is already loaded ... $Y SKIPPING $N"
fi

print_time

