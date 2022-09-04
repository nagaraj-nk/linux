#!/bin/bash
sudo yum update
sudo yum install ruby -y
sudo yum install wget -y
sudo yum install vim -y
sudo yum install java-11-openjdk -y
cd /home/ec2-user
sudo wget https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/latest/install
sudo chmod +x ./install
sudo ./install auto
sudo service codedeploy-agent start
sudo service codedeploy-agent restart
