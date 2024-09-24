pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS_ID = 'docker-credential' // Make sure this matches your Jenkins stored credentials
        GIT_CREDENTIALS_ID = 'github-credentials'
        DOCKER_IMAGE_NAME = 'harshp01/two-tier-app'
        SSH_KEY_PATH = "C:/Users/LENOVO/Downloads/target-server-key.ppk"
        EC2_USER = 'ubuntu'
        EC2_HOST = '43.204.142.65'
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
                    // Use a temporary login script to avoid interactive login issues
                    def loginCommand = """
                        echo "${DOCKER_PASSWORD}" | docker login -u "${DOCKER_USERNAME}" --password-stdin
                    """

                    // Create a temporary shell script to handle Docker login and image management
                    def deployScript = """
                        #!/bin/bash
                        ${loginCommand}
                        docker pull ${DOCKER_IMAGE_NAME}:latest
                        docker stop \$(docker ps -q) || true
                        docker rm \$(docker ps -aq) || true
                        docker run -d -p 80:80 ${DOCKER_IMAGE_NAME}:latest
                    """

                    // Save the script to a temporary file on the EC2 instance
                    bat """
                    plink -i ${SSH_KEY_PATH} ${EC2_USER}@${EC2_HOST} -batch "echo '${deployScript}' > deploy.sh; chmod +x deploy.sh; ./deploy.sh"
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
