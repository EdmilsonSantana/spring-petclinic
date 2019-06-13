#!/bin/bash

sudo docker volume create jenkins_data
#sudo docker volume create sonarqube_conf
#sudo docker volume create sonarqube_plugins
#sudo docker volume create nexus-data

./ci-restore.sh jenkins_data /var/jenkins_home 1.0
#./restore.sh sonarqube_conf 1.0
#./restore.sh sonarqube_plugins 1.0
#./restore.sh data 1.0

sudo docker-compose -f docker-compose-ci.yml up -d