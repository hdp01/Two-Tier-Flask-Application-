pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS_ID = 'docker-credential' // Your Docker Hub credentials ID
        GIT_CREDENTIALS_ID = 'github-credentials'    // Your GitHub credentials ID
        DOCKER_IMAGE_NAME = 'harshp01/two-tier-app'  // Your Docker image name
        EC2_PUBLIC_IP = '43.204.142.65'              // Your EC2 instance public IP
        SSH_KEY_PATH = 'C:/Users/LENOVO/Downloads/target-server-key.pem' // Path to your SSH key
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm // Check out the code from the GitHub repository
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', DOCKER_CREDENTIALS_ID) {
                        def app = docker.build(DOCKER_IMAGE_NAME) // Build the Docker image
                        app.push('latest') // Push the image to Docker Hub
                    }
                }
            }
        }

        stage('Deploy with Ansible') {
            steps {
                script {
                    // Using the local SSH key file directly in the bat command (for Windows)
                    bat """
                        ssh -o StrictHostKeyChecking=no -i ${SSH_KEY_PATH} ubuntu@${EC2_PUBLIC_IP} "ansible-playbook -i ansible/inventory ansible/playbook.yml -vvv"
                    """
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment completed successfully!' // Success message
        }
        failure {
            echo 'Deployment failed. Check the logs for more details.' // Failure message
        }
    }
}
