pipeline {
	agent {
		label 'docker-multiarch'
	}
	options {
		buildDiscarder(logRotator(numToKeepStr: '10'))
		disableConcurrentBuilds()
		ansiColor('xterm')
	}
	environment {
		IMAGE        = "ci-tools"
		BUILDX_NAME  = "${COMPOSE_PROJECT_NAME}"
		BRANCH_LOWER = "${BRANCH_NAME.toLowerCase().replaceAll('/', '-')}"
	}
	stages {
		stage('Environment') {
			parallel {
				stage('Master') {
					when {
						branch 'master'
					}
					steps {
						script {
							env.BUILDX_PUSH_TAGS = "-t docker.io/jc21/${IMAGE}:latest"
						}
					}
				}
				stage('Other') {
					when {
						not {
							branch 'master'
						}
					}
					steps {
						script {
							// Defaults to the Branch name, which is applies to all branches AND pr's
							env.BUILDX_PUSH_TAGS = "-t docker.io/jc21/${IMAGE}:github-${BRANCH_LOWER}"
						}
					}
				}
			}
		}
		stage('MultiArch Build') {
			steps {
				withCredentials([usernamePassword(credentialsId: 'jc21-dockerhub', passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
					// Docker Login
					sh 'docker login -u "${DOCKER_USER}" -p "${DOCKER_PASS}"'
					// Buildx with push from cache
					sh "./scripts/buildx --push -f docker/Dockerfile ${BUILDX_PUSH_TAGS}"
				}
			}
		}
	}
	post {
		success {
			juxtapose event: 'success'
			printSuccess()
		}
		failure {
			juxtapose event: 'failure'
			sh 'figlet "FAILURE"'
		}
	}
}
