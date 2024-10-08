pipeline {
    agent any
    environment {
        DOCKER_CREDENTIALS = credentials('docker-id')  // Ensure Docker credentials ID is correct
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', 
                    credentialsId: 'git-credentials',  // Ensure Git credentials ID is correct
                    url: 'https://github.com/Ramyasahithya/swe645CI-CD.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Login to Docker using credentials stored in Jenkins
                    sh 'echo $DOCKER_CREDENTIALS_PSW | docker login -u $DOCKER_CREDENTIALS_USR --password-stdin'

                    // Build the Docker image
                    image = docker.build("ramya0602/form:${env.BUILD_ID}")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    // Push the image to Docker Hub with the registry login using the credentials
                    docker.withRegistry('https://index.docker.io/v1/', DOCKER_CREDENTIALS) {
                        image.push()  // Push the Docker image
                    }
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
