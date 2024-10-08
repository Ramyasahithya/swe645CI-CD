pipeline {
    agent any
    environment {
        DOCKER_CREDENTIALS = credentials('Docker-id')  // Docker credentials
        KUBECONFIG_CREDENTIALS = credentials('kubeconfig-id')  // Kubernetes credentials
        IMAGE_TAG = "${env.BUILD_ID}"  // Set IMAGE_TAG to the Jenkins build ID
    }

    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'Docker-id', passwordVariable: 'DOCKER_PSW', usernameVariable: 'DOCKER_USR')]) {
                        sh 'echo $DOCKER_PSW | docker login -u $DOCKER_USR --password-stdin'
                    }

                    image = docker.build("ramya0602/form:${env.IMAGE_TAG}")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'Docker-id') {
                        image.push()
                    }
                }
            }
        }

        stage('Update Deployment YAML and Deploy') {
            steps {
                script {
                    // Ensure that ${IMAGE_TAG} in deployment.yaml is replaced with the actual image tag
                    sh "sed -i 's/\\\$IMAGE_TAG/${env.IMAGE_TAG}/g' deployment.yaml"

                    // Debugging step: Display the content of deployment.yaml after sed substitution
                    sh 'cat deployment.yaml'

                    // Apply the updated deployment.yaml to Kubernetes (Rancher)
                    sh '''
                    kubectl --kubeconfig=$KUBECONFIG_CREDENTIALS apply -f deployment.yaml
                    '''

                    // Optionally, apply the service.yaml if needed
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
