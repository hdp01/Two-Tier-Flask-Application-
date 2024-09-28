pipeline {
    agent any

    environment {
        DOCKER_IMAGE_NAME = 'harshp01/two-tier-app'
        SSH_KEY_PATH = "C:/Users/LENOVO/Downloads/target-server-key.ppk"
        EC2_USER = 'ubuntu'
        EC2_HOST = '13.232.34.22'
        DEPLOY_SCRIPT = 'deploy.sh'  // Name of the deploy script
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
                    docker.withRegistry('https://index.docker.io/v1/', 'docker-credential') {
                        def app = docker.build(DOCKER_IMAGE_NAME)
                        app.push('latest')
                    }
                }
            }
        }

        stage('Copy Deploy Script to EC2') {
            steps {
                script {
                    // Copy the deploy.sh script to the EC2 instance
                    bat """
                    pscp -i ${SSH_KEY_PATH} -hostkey "ssh-ed25519 255 SHA256:A2krnipHauwTsKo2dq9uXiUwnO4tcdhjLtxezm7B4qc" ${DEPLOY_SCRIPT} ${EC2_USER}@${EC2_HOST}:/home/${EC2_USER}/deploy.sh
                    """
                }
            }
        }

        stage('Make Script Executable and Deploy') {
            steps {
                script {
                    // Make the script executable and run it
                    bat """
                    plink -i ${SSH_KEY_PATH} ${EC2_USER}@${EC2_HOST} -batch "chmod +x /home/${EC2_USER}/deploy.sh && /home/${EC2_USER}/deploy.sh"
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
