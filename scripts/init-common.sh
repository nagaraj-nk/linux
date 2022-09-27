#!/bin/bash

echo 'ClientAliveInterval 60' | sudo tee --append /etc/ssh/sshd_config
sudo systemctl restart sshd

echo Installing JDK11
sudo yum install java-11-openjdk -y

echo Installing Wget
sudo yum install wget -y

echo installing vim
sudo yum install vim -y

cd /opt
echo Installing Maven
wget https://dlcdn.apache.org/maven/maven-3/3.8.6/binaries/apache-maven-3.8.6-bin.tar.gz
tar zxvf apache-maven-3.8.6-bin.tar.gz

# set maven home
set MAVEN_HOME=/opt/apache-maven-3.8.6
export MAVEN_HOME
set PATH="$PATH:$MAVEN_HOME/bin"

# set java home
export PATH
set JAVA_HOME=/usr/lib/jvm/java-11-openjdk-11.0.13.0.8-1.amzn2.0.3.x86_64
export JAVA_HOME
set PATH="$PATH:$JAVA_HOME/bin"
export PATH

# install git
echo Installing Git
sudo yum install git -y
mvn -version
java -version
git --version

mkdir employee
cd employee
mkdir scripts
mkdir config
mkdir logs
mkdir webhook-events
mkdir code
cd code

echo generating ssh key
ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa <<< y
echo "--------------------------------------"
cat /root/.ssh/id_rsa.pub
echo "--------------------------------------"

echo sending SSH Key to github
curl -X POST --data "{\"title\":\"ec2_prod_employee\",\"key\":\"`cat /root/.ssh/id_rsa.pub`\"}" -H "Accept: application/vnd.github+json" -H "Content-type: application/json" -H "Authorization: token TOKEN" https://api.github.com/user/keys
echo "------------------------------"

echo cloning code
ssh-keyscan -H github.com >> ~/.ssh/known_hosts
git clone git@github.com:nagaraj-nk/employee.git

cp /opt/employee/code/employee/misc/scripts/* /opt/employee/scripts/
cp /opt/employee/code/employee/misc/service/* /etc/systemd/system/
cp /opt/employee/code/employee/misc/config/* /opt/employee/config/

chmod 777 /opt/employee/scripts/*

systemctl daemon-reload
systemctl enable employee-app.service
systemctl enable employee-app-webhook.service

cd /opt/employee/code/employee/
/opt/employee/code/employee/mci.sh

cp /opt/employee/code/employee/employee/target/*jar /opt/employee/employee.jar

systemctl start employee-app.service
systemctl start employee-app-webhook.service
