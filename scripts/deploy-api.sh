#!/bin/bash
echo Employee API Deployment Started
echo Stopping Service
service employee-app.service stop

cd /opt/employee/code/employee
git pull origin master
/opt/employee/code/employee/mci.sh
cp /opt/employee/code/employee/employee/target/*.jar /opt/employee/employee.jar

echo Restarting Service
service employee-app.service start

echo Employee API Deployment Completed

