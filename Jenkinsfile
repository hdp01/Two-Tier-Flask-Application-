pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS_ID = 'docker-credential'
        GIT_CREDENTIALS_ID = 'github-credentials'
        DOCKER_IMAGE_NAME = 'harshp01/two-tier-app'
        SSH_KEY_PATH = "C:\Users\LENOVO\Downloads\target-server-key.pem" // Adjust this path to the location of your `.pem` file
        EC2_USER = 'ubuntu'
        EC2_HOST = '43.204.142.65' // Replace with your EC2 public IP address
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', DOCKER_CREDENTIALS_ID) {
                        def app = docker.build(DOCKER_IMAGE_NAME)
                        app.push('latest')
                    }
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                script {
                    // SSH into EC2 and run deployment commands
                    sh """
                    ssh -o StrictHostKeyChecking=no -i ${SSH_KEY_PATH} ${EC2_USER}@${EC2_HOST} '
                        docker login -u harshp01 -p your-dockerhub-password;
                        docker pull ${DOCKER_IMAGE_NAME}:latest;
                        docker stop \$(docker ps -q --filter ancestor=${DOCKER_IMAGE_NAME}:latest);
                        docker rm \$(docker ps -a -q --filter ancestor=${DOCKER_IMAGE_NAME}:latest);
                        docker run -d -p 80:5000 ${DOCKER_IMAGE_NAME}:latest
                    '
                    """
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment to EC2 successful!'
        }
        failure {
            echo 'Pipeline failed. Check the logs for more details.'
        }
    }
}
