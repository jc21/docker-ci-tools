pipeline {
  options {
    buildDiscarder(logRotator(numToKeepStr: '10'))
    disableConcurrentBuilds()
  }
  agent any
  environment {
    IMAGE      = "ci-tools"
    TEMP_IMAGE = "${IMAGE}-build_${BUILD_NUMBER}"
    // Architectures:
    AMD64_TAG  = "amd64"
    ARMV6_TAG  = "armv6l"
    ARMV7_TAG  = "armv7l"
    ARM64_TAG  = "aarch64"
  }
  stages {
    stage('Build') {
      when {
        branch 'master'
      }
      parallel {
        // ========================
        // amd64
        // ========================
        stage('amd64') {
          agent {
            label 'amd64'
          }
          steps {
            ansiColor('xterm') {
              // Docker Build
              sh 'docker build --pull --no-cache --squash --compress -t ${TEMP_IMAGE}-${AMD64_TAG} .'

              // Dockerhub
              sh 'docker tag ${TEMP_IMAGE}-${AMD64_TAG} docker.io/jc21/${IMAGE}:latest-${AMD64_TAG}'
              withCredentials([usernamePassword(credentialsId: 'jc21-dockerhub', passwordVariable: 'dpass', usernameVariable: 'duser')]) {
                sh "docker login -u '${duser}' -p '${dpass}'"
                sh 'docker push docker.io/jc21/${IMAGE}:latest-${AMD64_TAG}'
              }

              sh 'docker rmi ${TEMP_IMAGE}-${AMD64_TAG}'
            }
          }
        }
        // ========================
        // aarch64
        // ========================
        stage('aarch64') {
          agent {
            label 'aarch64'
          }
          steps {
            ansiColor('xterm') {
              // Docker Build
              sh 'docker build --pull --no-cache --squash --compress -f Dockerfile.${ARM64_TAG} -t ${TEMP_IMAGE}-${ARM64_TAG} .'

              // Dockerhub
              sh 'docker tag ${TEMP_IMAGE}-${ARM64_TAG} docker.io/jc21/$IMAGE:latest-${ARM64_TAG}'
              withCredentials([usernamePassword(credentialsId: 'jc21-dockerhub', passwordVariable: 'dpass', usernameVariable: 'duser')]) {
                sh "docker login -u '${duser}' -p '${dpass}'"
                sh 'docker push docker.io/jc21/${IMAGE}:latest-${ARM64_TAG}'
              }

              sh 'docker rmi ${TEMP_IMAGE}-${ARM64_TAG}'
            }
          }
        }
        // ========================
        // armv7l
        // ========================
        stage('armv7l') {
          agent {
            label 'armv7l'
          }
          steps {
            ansiColor('xterm') {
              // Docker Build
              sh 'docker build --pull --no-cache --squash --compress -f Dockerfile.${ARMV7_TAG} -t ${TEMP_IMAGE}-${ARMV7_TAG} .'

              // Dockerhub
              sh 'docker tag ${TEMP_IMAGE}-${ARMV7_TAG} docker.io/jc21/$IMAGE:latest-${ARMV7_TAG}'
              withCredentials([usernamePassword(credentialsId: 'jc21-dockerhub', passwordVariable: 'dpass', usernameVariable: 'duser')]) {
                sh "docker login -u '${duser}' -p '${dpass}'"
                sh 'docker push docker.io/jc21/${IMAGE}:latest-${ARMV7_TAG}'
              }

              sh 'docker rmi ${TEMP_IMAGE}-${ARMV7_TAG}'
            }
          }
        }
        // ========================
        // armv6l - Disabled for the time being
        // ========================
        /*
        stage('armv6l') {
          agent {
            label 'armv6l'
          }
          steps {
            ansiColor('xterm') {
              // Docker Build
              sh 'docker build --pull --no-cache --squash --compress -f Dockerfile.${ARMV6_TAG} -t ${TEMP_IMAGE}-${ARMV6_TAG} .'

              // Dockerhub
              sh 'docker tag ${ARMV6_TAG}-${ARMV6_TAG} docker.io/jc21/${IMAGE}:latest-${ARMV6_TAG}'
              withCredentials([usernamePassword(credentialsId: 'jc21-dockerhub', passwordVariable: 'dpass', usernameVariable: 'duser')]) {
                sh "docker login -u '${duser}' -p '${dpass}'"
                sh 'docker push docker.io/jc21/${IMAGE}:latest-${ARMV6_TAG}'
              }

              sh 'docker rmi ${TEMP_IMAGE}-${ARMV6_TAG}'
            }
          }
        }
        */
      }
    }
    // ========================
    // latest manifest
    // ========================
    stage('Latest Manifest') {
      when {
        branch 'master'
      }
      steps {
        ansiColor('xterm') {
          // =======================
          // latest
          // =======================
          sh 'docker pull jc21/${IMAGE}:latest-${AMD64_TAG}'
          sh 'docker pull jc21/${IMAGE}:latest-${ARM64_TAG}'
          sh 'docker pull jc21/${IMAGE}:latest-${ARMV7_TAG}'
          sh 'docker pull jc21/${IMAGE}:latest-${ARMV6_TAG}'

          sh 'docker manifest push --purge jc21/${IMAGE}:latest || :'
          sh 'docker manifest create jc21/${IMAGE}:latest jc21/${IMAGE}:latest-${AMD64_TAG} jc21/${IMAGE}:latest-${ARM64_TAG} jc21/${IMAGE}:latest-${ARMV7_TAG} jc21/${IMAGE}:latest-${ARMV6_TAG}'

          sh 'docker manifest annotate jc21/${IMAGE}:latest jc21/${IMAGE}:latest-${AMD64_TAG} --arch ${AMD64_TAG}'
          sh 'docker manifest annotate jc21/${IMAGE}:latest jc21/${IMAGE}:latest-${ARM64_TAG} --arch ${ARM64_TAG}'
          sh 'docker manifest annotate jc21/${IMAGE}:latest jc21/${IMAGE}:latest-${ARMV7_TAG} --arch arm --variant ${ARMV7_TAG}'
          sh 'docker manifest annotate jc21/${IMAGE}:latest jc21/${IMAGE}:latest-${ARMV6_TAG} --arch arm --variant ${ARMV6_TAG}'
          sh 'docker manifest push --purge jc21/${IMAGE}:latest'
        }
      }
    }
    // ========================
    // cleanup
    // ========================
    stage('Latest Cleanup') {
      when {
        branch 'master'
      }
      steps {
        ansiColor('xterm') {
          sh 'docker rmi jc21/${IMAGE}:latest'
          sh 'docker rmi jc21/${IMAGE}:latest-${AMD64_TAG}'
          sh 'docker rmi jc21/${IMAGE}:latest-${ARM64_TAG}'
          sh 'docker rmi jc21/${IMAGE}:latest-${ARMV7_TAG}'
          sh 'docker rmi jc21/${IMAGE}:latest-${ARMV6_TAG}'
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
