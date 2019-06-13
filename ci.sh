#!/bin/bash

restore() {
    version=$1
        
    sudo docker-compose -f docker-compose-ci.yml stop && \
    sudo docker-compose -f docker-compose-ci.yml rm

    echo "Criando volumes..."

    sudo docker volume rm jenkins_data
    sudo docker volume create jenkins_data

    sudo docker volume rm sonarqube_conf
    sudo docker volume create sonarqube_conf

    sudo docker volume rm sonarqube_plugins
    sudo docker volume create sonarqube_plugins

    sudo docker volume rm postgres_data
    sudo docker volume create postgres_data

    sudo docker volume rm nexus_data
    sudo docker volume create nexus_data

    echo "Restaurando volumes da versão ${version}..."

    ./ci-restore.sh jenkins_data /var/jenkins_home $version
    ./ci-restore.sh sonarqube_conf /opt/sonarqube/conf $version
    ./ci-restore.sh sonarqube_plugins /opt/sonarqube/extensions/plugins $version
    ./ci-restore.sh postgres_data /var/lib/postgresql/data $version
    ./ci-restore.sh nexus_data /nexus-data $version

    echo "Implantando ambiente de CI..."

    sudo docker-compose -f docker-compose-ci.yml up -d
}

backup() {
    version=$1
    
    echo "Realizando backup da versão ${version}..."

    ./ci-backup.sh jenkins jenkins_data /var/jenkins_home $version
    ./ci-backup.sh sonarqube sonarqube_conf /opt/sonarqube/conf $version
    ./ci-backup.sh sonarqube sonarqube_plugins /opt/sonarqube/extensions/plugins $version
    ./ci-backup.sh sonarqube_db postgres_data /var/lib/postgresql/data $version
    ./ci-backup.sh nexus nexus_data nexus-data $version
}

while getopts :b:r: opt; do
    case ${opt} in
        b ) backup $OPTARG
        ;;
        r ) restore $OPTARG
        ;;
        \? ) echo "Usage: ci [-b] [-r]" 
        ;;
    esac
done
  
  