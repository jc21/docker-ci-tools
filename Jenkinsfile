pipeline {
  options {
    buildDiscarder(logRotator(numToKeepStr: '10'))
    disableConcurrentBuilds()
  }
  agent {
    label 'internal'
  }
  environment {
    IMAGE_NAME          = "ci-tools"
    TEMP_IMAGE_NAME     = "ci-tools-build_${BUILD_NUMBER}"
    TEMP_IMAGE_NAME_ARM = "ci-tools-arm-build_${BUILD_NUMBER}"
  }
  stages {
    stage('Build') {
      parallel {
        stage('x86_64') {
          agent {
            label 'internal'
          }
          steps {
            ansiColor('xterm') {
              // Docker Build
              sh 'docker build --pull --no-cache --squash --compress -t $TEMP_IMAGE_NAME .'

              // Private Registry
              sh 'docker tag $TEMP_IMAGE_NAME $DOCKER_PRIVATE_REGISTRY/$IMAGE_NAME:latest'
              sh 'docker push $DOCKER_PRIVATE_REGISTRY/$IMAGE_NAME:latest'
              sh 'docker rmi $TEMP_IMAGE_NAME'

              // Dockerhub
              withCredentials([usernamePassword(credentialsId: 'jc21-dockerhub', passwordVariable: 'dpass', usernameVariable: 'duser')]) {
                sh "docker login -u '${duser}' -p '$dpass'"
                sh 'docker push docker.io/jc21/$IMAGE_NAME:latest'
              }
            }
          }
        }
        stage('armhf') {
          agent {
            label 'armhf-internal'
          }
          steps {
            ansiColor('xterm') {
              // Docker Build
              sh 'docker build --pull --no-cache --squash --compress -f Dockerfile.armhf -t $TEMP_IMAGE_NAME_ARM .'

              // Private Registry
              sh 'docker tag $TEMP_IMAGE_NAME_ARM $DOCKER_PRIVATE_REGISTRY/$IMAGE_NAME:latest-armhf'
              sh 'docker push $DOCKER_PRIVATE_REGISTRY/$IMAGE_NAME:latest-armhf'
              sh 'docker rmi $TEMP_IMAGE_NAME_ARM'

              // Dockerhub
              withCredentials([usernamePassword(credentialsId: 'jc21-dockerhub', passwordVariable: 'dpass', usernameVariable: 'duser')]) {
                sh "docker login -u '${duser}' -p '$dpass'"
                sh 'docker push docker.io/jc21/$IMAGE_NAME:latest-armhf'
              }
            }
          }
        }
      }
    }
  }
  triggers {
    bitbucketPush()
  }
  post {
    success {
      juxtapose event: 'success'
      sh 'figlet "SUCCESS"'
    }
    failure {
      juxtapose event: 'failure'
      sh 'figlet "FAILURE"'
    }
  }
}
