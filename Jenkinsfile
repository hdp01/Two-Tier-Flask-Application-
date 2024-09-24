pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS_ID = 'docker-credential' // Your Jenkins stored Docker credentials ID
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
                    withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS_ID, usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        // Create a deploy command string without Groovy interpolation for password
                        def deployCommand = """
                            echo "${DOCKER_PASSWORD}" | docker login -u "${DOCKER_USERNAME}" --password-stdin && \
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
