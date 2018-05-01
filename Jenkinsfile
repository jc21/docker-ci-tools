pipeline {
  agent any
  stages {
    stage('Prepare') {
      steps {
        sh '''docker pull centos:7
exit 0'''
      }
    }
    stage('Build') {
      steps {
        sh '''IMAGE_NAME="ci-tools"
TAG_NAME="latest"

TEMP_IMAGE_NAME="${IMAGE_NAME}-${TAG_NAME}_${BUILD_NUMBER}"
FINAL_IMAGE_NAME="${DOCKER_PRIVATE_REGISTRY}/${IMAGE_NAME}:${TAG_NAME}"

# Build
echo "Building temp image..."
docker build -t ${TEMP_IMAGE_NAME} .
rc=$?; if [ $rc != 0 ]; then exit $rc; fi
'''
      }
    }
    stage('Publish') {
      steps {
        sh '''IMAGE_NAME="ci-tools"
TAG_NAME="latest"

TEMP_IMAGE_NAME="${IMAGE_NAME}-${TAG_NAME}_${BUILD_NUMBER}"
FINAL_IMAGE_NAME="${DOCKER_PRIVATE_REGISTRY}/${IMAGE_NAME}:${TAG_NAME}"

# Tag
echo "Tagging new image..."
docker tag ${TEMP_IMAGE_NAME} ${FINAL_IMAGE_NAME}
rc=$?; if [ $rc != 0 ]; then exit $rc; fi

# Remove temp image
echo "Removing temp image..."
docker rmi ${TEMP_IMAGE_NAME}

# Upload entire php image and all tags:
echo "Uploading new image..."
docker push ${FINAL_IMAGE_NAME}
rc=$?; if [ $rc != 0 ]; then exit $rc; fi'''
      }
    }
  }
  triggers {
    bitbucketPush()
  }
  post {
    success {
      slackSend color: "#72c900", message: "<${BUILD_URL}|${JOB_NAME}> build #${BUILD_NUMBER} completed"
    }
    failure {
      slackSend color: "#d61111", message: "<${BUILD_URL}|${JOB_NAME}> build #${BUILD_NUMBER} failed"
    }
  }
}
