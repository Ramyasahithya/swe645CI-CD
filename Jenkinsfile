pipeline {
    agent any
    environment {
        DOCKER_CREDENTIALS = credentials('Docker-id') 
        KUBECONFIG_CREDENTIALS = credentials('kubeconfig-id') 
    }

    stages {
        stage('Checkout Code') {
            steps {
               
                git 'https://github.com/Ramyasahithya/swe645CI-CD.git' 
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh 'echo $DOCKER_CREDENTIALS_PSW | docker login -u $DOCKER_CREDENTIALS_USR --password-stdin'
                    image = docker.build("ramya0602/form:${env.BUILD_ID}")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', DOCKER_CREDENTIALS) {
                        image.push()
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh '''
                        kubectl --kubeconfig=$KUBECONFIG_CREDENTIALS apply -f deployment.yaml
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
