pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS_ID = 'docker-credential'
        GIT_CREDENTIALS_ID = 'github-credentials'
        DOCKER_IMAGE_NAME = 'harshp01/two-tier-app'
        EC2_PUBLIC_IP = '43.204.142.65'
        SSH_KEY_PATH = 'C:/Users/LENOVO/Downloads/target-server-key.pem'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('List Ansible Directory') {
            steps {
                script {
                    bat 'dir ansible'
                }
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

        stage('Deploy with Ansible') {
            steps {
                script {
                    // Copy ansible directory to EC2
                    bat """
                        scp -o StrictHostKeyChecking=no -i ${SSH_KEY_PATH} -r ansible ubuntu@${EC2_PUBLIC_IP}:~
                    """
                    // Run ansible playbook
                    bat """
                        ssh -o StrictHostKeyChecking=no -i ${SSH_KEY_PATH} ubuntu@${EC2_PUBLIC_IP} "ansible-playbook -i ~/ansible/inventory ~/ansible/playbook.yml -vvv"
                    """
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment completed successfully!'
        }
        failure {
            echo 'Deployment failed. Check the logs for more details.'
        }
    }
}
