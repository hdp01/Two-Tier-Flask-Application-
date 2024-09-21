pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS_ID = 'docker-credential'  // Your Docker Hub credentials ID in Jenkins
        GIT_CREDENTIALS_ID = 'github-credentials'     // Your GitHub credentials ID in Jenkins
        DOCKER_IMAGE_NAME = 'harshp01/two-tier-app'   // Your Docker Hub image name
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm // Checkout the code from your Git repository
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Log in to Docker Hub and build the image
                    docker.withRegistry('https://index.docker.io/v1/', DOCKER_CREDENTIALS_ID) {
                        def app = docker.build(DOCKER_IMAGE_NAME) // Build the Docker image
                        app.push('latest') // Push the image with the 'latest' tag
                    }
                }
            }
        }

        stage('Deploy with Ansible') {
            steps {
                sshagent([GIT_CREDENTIALS_ID]) { // Use the GitHub credentials to run the Ansible playbook
                    sh 'ansible-playbook -i ansible/inventory ansible/playbook.yml' // Run the Ansible playbook
                }
            }
        }
    }
}
