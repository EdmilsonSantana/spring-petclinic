pipeline {
 environment {
  registry = "http://localhost:8123"
  registryCredential = 'nexus'
 }

 tools {
  maven "maven"
 }

 agent any

 stages {

  stage('Build') {
   steps {
    sh 'mvn -Dmaven.test.skip=true clean package'
   }
  }

  stage('Test') {
   steps {
    sh 'mvn test'
   }
   post {
    always {
     junit 'target/surefire-reports/*.xml'
    }
   }
  }

  stage('Sonarqube') {
   steps {
    withSonarQubeEnv('sonarqube') {
     sh 'mvn sonar:sonar'
    }
   }
  }

  stage('Delivery') {
   steps {
    script {
     def image = docker.build("devops/petclinic", "-f Dockerfile.ci .")
     docker.withRegistry(registry, registryCredential) {
      image.push("${env.BUILD_NUMBER}")
      image.push("latest")
     }
    }
   }
  }
 }
}