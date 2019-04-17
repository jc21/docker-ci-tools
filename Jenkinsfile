pipeline {
  options {
    buildDiscarder(logRotator(numToKeepStr: '10'))
    disableConcurrentBuilds()
  }
  agent any
  environment {
    IMAGE      = "ci-tools"
    TEMP_IMAGE = "${IMAGE}-build_${BUILD_NUMBER}"
    // Registries
    DOCKERHUB  = "docker.io/jc21"
    PRIVATEHUB = "docker.jc21.net.au/jcurnow"
    // Architectures:
    AMD64_TAG  = "amd64"
    ARMV6_TAG  = "armv6l"
    ARMV7_TAG  = "armv7l"
    ARM64_TAG  = "arm64"
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
              sh 'docker tag ${TEMP_IMAGE}-${AMD64_TAG} ${DOCKERHUB}/${IMAGE}:latest-${AMD64_TAG}'
              withCredentials([usernamePassword(credentialsId: 'jc21-dockerhub', passwordVariable: 'dpass', usernameVariable: 'duser')]) {
                sh "docker login -u '${duser}' -p '${dpass}'"
                sh 'docker push ${DOCKERHUB}/${IMAGE}:latest-${AMD64_TAG}'
              }

              // Private Registry
              sh 'docker tag ${TEMP_IMAGE}-${AMD64_TAG} ${PRIVATEHUB}/${IMAGE}:latest-${AMD64_TAG}'
              withCredentials([usernamePassword(credentialsId: 'jc21-private-registry', passwordVariable: 'dpass', usernameVariable: 'duser')]) {
                sh "docker login -u '${duser}' -p '${dpass}' docker.jc21.net.au"
                sh 'docker push ${PRIVATEHUB}/${IMAGE}:latest-${AMD64_TAG}'
              }

              sh 'docker rmi ${TEMP_IMAGE}-${AMD64_TAG}'
            }
          }
        }
        // ========================
        // arm64
        // ========================
        stage('arm64') {
          agent {
            label 'arm64'
          }
          steps {
            ansiColor('xterm') {
              // Docker Build
              sh 'docker build --pull --no-cache --squash --compress -f Dockerfile.${ARM64_TAG} -t ${TEMP_IMAGE}-${ARM64_TAG} .'

              // Dockerhub
              sh 'docker tag ${TEMP_IMAGE}-${ARM64_TAG} ${DOCKERHUB}/${IMAGE}:latest-${ARM64_TAG}'
              withCredentials([usernamePassword(credentialsId: 'jc21-dockerhub', passwordVariable: 'dpass', usernameVariable: 'duser')]) {
                sh "docker login -u '${duser}' -p '${dpass}'"
                sh 'docker push ${DOCKERHUB}/${IMAGE}:latest-${ARM64_TAG}'
              }

              // Private Registry
              sh 'docker tag ${TEMP_IMAGE}-${ARM64_TAG} ${PRIVATEHUB}/${IMAGE}:latest-${ARM64_TAG}'
              withCredentials([usernamePassword(credentialsId: 'jc21-private-registry', passwordVariable: 'dpass', usernameVariable: 'duser')]) {
                sh "docker login -u '${duser}' -p '${dpass}' docker.jc21.net.au"
                sh 'docker push ${PRIVATEHUB}/${IMAGE}:latest-${ARM64_TAG}'
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
              sh 'docker tag ${TEMP_IMAGE}-${ARMV7_TAG} ${DOCKERHUB}/${IMAGE}:latest-${ARMV7_TAG}'
              withCredentials([usernamePassword(credentialsId: 'jc21-dockerhub', passwordVariable: 'dpass', usernameVariable: 'duser')]) {
                sh "docker login -u '${duser}' -p '${dpass}'"
                sh 'docker push ${DOCKERHUB}/${IMAGE}:latest-${ARMV7_TAG}'
              }

              // Private Registry
              sh 'docker tag ${TEMP_IMAGE}-${ARMV7_TAG} ${PRIVATEHUB}/${IMAGE}:latest-${ARMV7_TAG}'
              withCredentials([usernamePassword(credentialsId: 'jc21-private-registry', passwordVariable: 'dpass', usernameVariable: 'duser')]) {
                sh "docker login -u '${duser}' -p '${dpass}' docker.jc21.net.au"
                sh 'docker push ${PRIVATEHUB}/${IMAGE}:latest-${ARMV7_TAG}'
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
              sh 'docker tag ${ARMV6_TAG}-${ARMV6_TAG} ${DOCKERHUB}/jc21/${IMAGE}:latest-${ARMV6_TAG}'
              withCredentials([usernamePassword(credentialsId: 'jc21-dockerhub', passwordVariable: 'dpass', usernameVariable: 'duser')]) {
                sh "docker login -u '${duser}' -p '${dpass}'"
                sh 'docker push ${DOCKERHUB}/${IMAGE}:latest-${ARMV6_TAG}'
              }

              // Private Registry
              sh 'docker tag ${TEMP_IMAGE}-${ARMV6_TAG} ${PRIVATEHUB}/${IMAGE}:latest-${ARMV6_TAG}'
              withCredentials([usernamePassword(credentialsId: 'jc21-private-registry', passwordVariable: 'dpass', usernameVariable: 'duser')]) {
                sh "docker login -u '${duser}' -p '${dpass}' docker.jc21.net.au"
                sh 'docker push ${PRIVATEHUB}/${IMAGE}:latest-${ARMV6_TAG}'
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
          // latest - dockerhub
          // =======================
          withCredentials([usernamePassword(credentialsId: 'jc21-dockerhub', passwordVariable: 'dpass', usernameVariable: 'duser')]) {
            sh "docker login -u '${duser}' -p '${dpass}'"

            sh 'docker pull ${DOCKERHUB}/${IMAGE}:latest-${AMD64_TAG}'
            sh 'docker pull ${DOCKERHUB}/${IMAGE}:latest-${ARM64_TAG}'
            sh 'docker pull ${DOCKERHUB}/${IMAGE}:latest-${ARMV7_TAG}'
            sh 'docker pull ${DOCKERHUB}/${IMAGE}:latest-${ARMV6_TAG}'

            sh 'docker manifest push --purge ${DOCKERHUB}/${IMAGE}:latest || :'
            sh 'docker manifest create ${DOCKERHUB}/${IMAGE}:latest ${DOCKERHUB}/${IMAGE}:latest-${AMD64_TAG} ${DOCKERHUB}/${IMAGE}:latest-${ARM64_TAG} ${DOCKERHUB}/${IMAGE}:latest-${ARMV7_TAG} ${DOCKERHUB}/${IMAGE}:latest-${ARMV6_TAG}'

            sh 'docker manifest annotate ${DOCKERHUB}/${IMAGE}:latest ${DOCKERHUB}/${IMAGE}:latest-${AMD64_TAG} --arch ${AMD64_TAG}'
            sh 'docker manifest annotate ${DOCKERHUB}/${IMAGE}:latest ${DOCKERHUB}/${IMAGE}:latest-${ARM64_TAG} --os linux --arch ${ARM64_TAG}'
            sh 'docker manifest annotate ${DOCKERHUB}/${IMAGE}:latest ${DOCKERHUB}/${IMAGE}:latest-${ARMV7_TAG} --os linux --arch arm --variant ${ARMV7_TAG}'
            sh 'docker manifest annotate ${DOCKERHUB}/${IMAGE}:latest ${DOCKERHUB}/${IMAGE}:latest-${ARMV6_TAG} --os linux --arch arm --variant ${ARMV6_TAG}'
            sh 'docker manifest push --purge ${DOCKERHUB}/${IMAGE}:latest'
          }

          // =======================
          // latest - private
          // =======================
          withCredentials([usernamePassword(credentialsId: 'jc21-private-registry', passwordVariable: 'dpass', usernameVariable: 'duser')]) {
            sh "docker login -u '${duser}' -p '${dpass}' docker.jc21.net.au"

            sh 'docker pull ${PRIVATEHUB}/${IMAGE}:latest-${AMD64_TAG}'
            sh 'docker pull ${PRIVATEHUB}/${IMAGE}:latest-${ARM64_TAG}'
            sh 'docker pull ${PRIVATEHUB}/${IMAGE}:latest-${ARMV7_TAG}'
            sh 'docker pull ${PRIVATEHUB}/${IMAGE}:latest-${ARMV6_TAG}'

            sh 'docker manifest push --purge ${PRIVATEHUB}/${IMAGE}:latest || :'
            sh 'docker manifest create ${PRIVATEHUB}/${IMAGE}:latest ${PRIVATEHUB}/${IMAGE}:latest-${AMD64_TAG} ${PRIVATEHUB}/${IMAGE}:latest-${ARM64_TAG} ${PRIVATEHUB}/${IMAGE}:latest-${ARMV7_TAG} ${PRIVATEHUB}/${IMAGE}:latest-${ARMV6_TAG}'

            sh 'docker manifest annotate ${PRIVATEHUB}/${IMAGE}:latest ${PRIVATEHUB}/${IMAGE}:latest-${AMD64_TAG} --arch ${AMD64_TAG}'
            sh 'docker manifest annotate ${PRIVATEHUB}/${IMAGE}:latest ${PRIVATEHUB}/${IMAGE}:latest-${ARM64_TAG} --os linux --arch ${ARM64_TAG}'
            sh 'docker manifest annotate ${PRIVATEHUB}/${IMAGE}:latest ${PRIVATEHUB}/${IMAGE}:latest-${ARMV7_TAG} --os linux --arch arm --variant ${ARMV7_TAG}'
            sh 'docker manifest annotate ${PRIVATEHUB}/${IMAGE}:latest ${PRIVATEHUB}/${IMAGE}:latest-${ARMV6_TAG} --os linux --arch arm --variant ${ARMV6_TAG}'
            sh 'docker manifest push --purge ${PRIVATEHUB}/${IMAGE}:latest'
          }
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
          sh 'docker rmi ${DOCKERHUB}/${IMAGE}:latest'
          sh 'docker rmi ${DOCKERHUB}/${IMAGE}:latest-${AMD64_TAG}'
          sh 'docker rmi ${DOCKERHUB}/${IMAGE}:latest-${ARM64_TAG}'
          sh 'docker rmi ${DOCKERHUB}/${IMAGE}:latest-${ARMV7_TAG}'
          sh 'docker rmi ${DOCKERHUB}/${IMAGE}:latest-${ARMV6_TAG}'
          sh 'docker rmi ${PRIVATEHUB}/${IMAGE}:latest'
          sh 'docker rmi ${PRIVATEHUB}/${IMAGE}:latest-${AMD64_TAG}'
          sh 'docker rmi ${PRIVATEHUB}/${IMAGE}:latest-${ARM64_TAG}'
          sh 'docker rmi ${PRIVATEHUB}/${IMAGE}:latest-${ARMV7_TAG}'
          sh 'docker rmi ${PRIVATEHUB}/${IMAGE}:latest-${ARMV6_TAG}'
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
