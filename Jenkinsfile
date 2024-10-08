pipeline {
    agent any
    environment {
        DOCKER_CREDENTIALS = credentials('Docker-id')  // Docker credentials
        KUBECONFIG_CREDENTIALS = credentials('kubeconfig-id')  // Kubernetes credentials
    }

    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    // Log in to Docker using credentials from Jenkins
                    withCredentials([usernamePassword(credentialsId: 'Docker-id', passwordVariable: 'DOCKER_PSW', usernameVariable: 'DOCKER_USR')]) {
                        sh 'echo $DOCKER_PSW | docker login -u $DOCKER_USR --password-stdin'
                    }

                    // Build the Docker image and tag it with the Jenkins build ID
                    image = docker.build("ramya0602/form:${env.BUILD_ID}")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    // Push the Docker image to the registry
                    docker.withRegistry('https://index.docker.io/v1/', 'Docker-id') {
                        image.push()
                    }
                }
            }
        }

        stage('Deploy to Rancher') {
            steps {
                script {
                    // Replace the IMAGE_TAG placeholder in deployment.yaml with the Jenkins build ID
                    sh "sed -i 's#\\${IMAGE_TAG}#${env.BUILD_ID}#' deployment.yaml"

                    // Apply deployment.yaml to update the Kubernetes deployment with the new image
                    sh '''
                    kubectl --kubeconfig=$KUBECONFIG_CREDENTIALS apply -f deployment.yaml
                    '''

                    // Apply service.yaml to ensure the service is created/updated
                    sh '''
                    kubectl --kubeconfig=$KUBECONFIG_CREDENTIALS apply -f service.yaml
                    '''
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed.'
        }
    }
}
