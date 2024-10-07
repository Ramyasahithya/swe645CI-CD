pipeline {
    agent any
    environment {
        DOCKER_CREDENTIALS = credentials('Docker-id') 
        KUBECONFIG_CREDENTIALS = credentials('kubeconfig-id') 
    }
    stages {
        stage('Checkout Code') {
            steps {
                git 'https://github.com/Ramyasahithya/SWE645.git' 
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    def image = docker.build("ramya0602/form:${env.BUILD_ID}")
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', DOCKER_CREDENTIALS_ID) {
                        image.push()
                    }
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh '''
                        kubectl --kubeconfig=$KUBECONFIG apply -f deployment.yaml
                        kubectl --kubeconfig=$KUBECONFIG apply -f service.yaml
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
