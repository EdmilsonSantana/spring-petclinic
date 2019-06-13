#!/bin/bash

restore() {
    echo "Criando volumes..."
    
    sudo docker volume create jenkins_data
    sudo docker volume create sonarqube_conf
    sudo docker volume create sonarqube_plugins
    sudo docker volume create postgres_data
    sudo docker volume create nexus_data

    echo "Restaurando volumes..."

    ./ci-restore.sh jenkins_data /var/jenkins_home 1.0
    ./ci-restore.sh sonarqube_conf /opt/sonarqube/conf 1.0
    ./ci-restore.sh sonarqube_plugins /opt/sonarqube/extensions/plugins 1.0
    ./ci-restore.sh postgres_data /var/lib/postgresql/data 1.0
    ./ci-restore.sh nexus_data /nexus-data 1.0

    echo "Implantando ambiente de CI..."

    sudo docker-compose -f docker-compose-ci.yml up -d
}

backup() {
    echo "Realizando backup..."
    ./ci-backup.sh jenkins jenkins_data /var/jenkins_home 1.0
    ./ci-backup.sh sonarqube sonarqube_conf /opt/sonarqube/conf 1.0
    ./ci-backup.sh sonarqube sonarqube_plugins /opt/sonarqube/extensions/plugins 1.0
    ./ci-backup.sh sonarqube_db postgres_data /var/lib/postgresql/data 1.0
    ./ci-backup.sh nexus nexus_data nexus-data 1.0
}

while getopts :br opt; do
    case ${opt} in
        b ) backup
        ;;
        r ) restore
        ;;
        \? ) echo "Usage: ci [-b] [-r]" 
        ;;
    esac
done
  
  