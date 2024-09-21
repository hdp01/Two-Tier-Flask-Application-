pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS_ID = 'docker-credential' // Your Docker Hub credentials ID
        GIT_CREDENTIALS_ID = 'github-credentials'    // Your GitHub credentials ID
        SSH_CREDENTIALS_ID = 'ec2-ssh-key'           // Your EC2 SSH credentials ID
        DOCKER_IMAGE_NAME = 'harshp01/two-tier-app'  // Your Docker image name
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
                sshagent([SSH_CREDENTIALS_ID]) { // Use the SSH credentials for EC2
                    sh 'ansible-playbook -i ansible/inventory ansible/playbook.yml' // Run the Ansible playbook
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
