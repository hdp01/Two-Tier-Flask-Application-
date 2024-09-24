pipeline {
    agent any

    environment {
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
                    docker.withRegistry('https://index.docker.io/v1/', 'docker-credential') {
                        def app = docker.build(DOCKER_IMAGE_NAME)
                        app.push('latest')
                    }
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                script {
                    // Create a deploy command string
                    def deployCommand = """
                        docker pull ${DOCKER_IMAGE_NAME}:latest && \
                        docker stop \$(docker ps -q) || true && \
                        docker rm \$(docker ps -aq) || true && \
                        docker run -d -p 80:80 ${DOCKER_IMAGE_NAME}:latest
                    """.replace('$', '\\$') // Escape $ for proper handling

                    // Execute commands directly via plink
                    bat """
                    plink -i ${SSH_KEY_PATH} ${EC2_USER}@${EC2_HOST} -batch "${deployCommand.trim()}"
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
