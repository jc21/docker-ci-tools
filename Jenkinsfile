pipeline {
  options {
    buildDiscarder(logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '', numToKeepStr: '10'))
    disableConcurrentBuilds()
  }
  agent any
  environment {
    IMAGE_NAME      = "ci-tools"
    TEMP_IMAGE_NAME = "ci-tools-build_${BUILD_NUMBER}"
  }
  stages {
    stage('Prepare') {
      steps {
        sh 'docker pull centos:7'
      }
    }
    stage('Build') {
      steps {
        sh 'docker build --squash --compress -t ${TEMP_IMAGE_NAME} .'
      }
    }
    stage('Publish') {
      steps {
        sh 'docker tag ${TEMP_IMAGE_NAME} ${FINAL_IMAGE_NAME}'
        sh 'docker tag $TEMP_IMAGE_NAME $DOCKER_PRIVATE_REGISTRY/$IMAGE_NAME:latest'
        sh 'docker push $DOCKER_PRIVATE_REGISTRY/$IMAGE_NAME:latest'
      }
    }
  }
  triggers {
    bitbucketPush()
  }
  post {
    success {
      slackSend color: "#72c900", message: "SUCCESS: <${BUILD_URL}|${JOB_NAME}> build #${BUILD_NUMBER} - ${currentBuild.durationString}"
      juxtapose event: 'success'
      sh 'figlet "SUCCESS"'
    }
    failure {
      slackSend color: "#d61111", message: "FAILED: <${BUILD_URL}|${JOB_NAME}> build #${BUILD_NUMBER} - ${currentBuild.durationString}"
      juxtapose event: 'failure'
      sh 'figlet "FAILURE"'
    }
    always {
      sh 'docker rmi  $TEMP_IMAGE_NAME'
    }
  }
}
