pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'smymuna/studentsurvey'      // Docker image name
        DOCKER_TAG = '0.1'                // Tag for the Docker image
        DEPLOYMENT_YAML_PATH = 'deployment.yaml'  // Path to deployment YAML
        SERVICE_YAML_PATH = 'service.yaml'   // Path to service YAML
    }

    stages {
        stage('Clone Repository') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}:${DOCKER_TAG}")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-ms', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh "echo \$DOCKER_PASSWORD | docker login --username \$DOCKER_USERNAME --password-stdin"
                        docker.image("${DOCKER_IMAGE}:${DOCKER_TAG}").push()
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh "kubectl apply -f ${DEPLOYMENT_YAML_PATH} --kubeconfig /var/lib/jenkins/.kube/config"
                    sh "kubectl apply -f ${SERVICE_YAML_PATH} --kubeconfig /var/lib/jenkins/.kube/config"
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment successful!'
        }
        failure {
            echo 'Deployment failed!'
        }
    }
}
