pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS_ID = 'docker-credential' // Ensure this is set up in Jenkins
        GIT_CREDENTIALS_ID = 'github-credentials' // Ensure this is set up in Jenkins
        DOCKER_IMAGE_NAME = 'harshp01/two-tier-app'
        SSH_KEY_PATH = "C:/Users/LENOVO/Downloads/target-server-key.ppk" // Use the PPK file
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
                    // Use plink (part of PuTTY) to SSH into EC2 from Windows
                    bat """
                    plink -i ${SSH_KEY_PATH} ${EC2_USER}@${EC2_HOST} -batch "
                        echo %DOCKER_PASSWORD% | docker login -u %DOCKER_USERNAME% --password-stdin;
                        docker pull ${DOCKER_IMAGE_NAME}:latest;
                        for /f %%i in ('docker ps -q --filter "ancestor=${DOCKER_IMAGE_NAME}:latest"') do docker stop %%i;
                        for /f %%i in ('docker ps -a -q --filter "ancestor=${DOCKER_IMAGE_NAME}:latest"') do docker rm %%i;
                        docker run -d -p 80:5000 ${DOCKER_IMAGE_NAME}:latest
                    "
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
