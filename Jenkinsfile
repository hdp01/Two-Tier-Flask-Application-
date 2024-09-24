pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS_ID = 'docker-credential'
        GIT_CREDENTIALS_ID = 'github-credentials'
        DOCKER_IMAGE_NAME = 'harshp01/two-tier-app'
        SSH_KEY_PATH = "C:/Users/LENOVO/Downloads/target-server-key.ppk" // Ensure this is the correct key format
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
                    bat """
                    plink -i C:/Users/LENOVO/Downloads/target-server-key.ppk ubuntu@43.204.142.65 -batch " \
                    echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin; \
                    docker pull harshp01/two-tier-app:latest; \
                    docker stop \$(docker ps -q); \
                    docker rm \$(docker ps -aq); \
                    docker run -d -p 80:80 harshp01/two-tier-app:latest"
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
