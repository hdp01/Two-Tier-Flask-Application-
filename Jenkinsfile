pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS_ID = 'docker-credential' // Docker Hub credentials ID
        GIT_CREDENTIALS_ID = 'github-credentials'    // GitHub credentials ID
        DOCKER_IMAGE_NAME = 'harshp01/two-tier-app'  // Docker image name
        EC2_PUBLIC_IP = '43.204.142.65'              // EC2 instance public IP
        SSH_KEY_PATH = 'C:/Users/LENOVO/Downloads/target-server-key.pem' // Path to SSH key
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm // Check out the code from the GitHub repository
            }
        }

        stage('List Ansible Directory') {
            steps {
                script {
                    bat 'dir ansible' // List the contents of the ansible directory
                }
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
                    // Copy ansible directory to EC2
                    bat """
                        scp -o StrictHostKeyChecking=no -i ${SSH_KEY_PATH} -r ansible ubuntu@${EC2_PUBLIC_IP}:~
                    """
                    // Run ansible playbook
                    bat """
                        ssh -o StrictHostKeyChecking=no -i ${SSH_KEY_PATH} ubuntu@${EC2_PUBLIC_IP} "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ~/ansible/inventory ~/ansible/playbook.yml -vvv"
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
