pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS_ID = 'docker-credential'
        GIT_CREDENTIALS_ID = 'github-credentials'
        DOCKER_IMAGE_NAME = 'harshp01/two-tier-app'
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

        stage('Deploy with Ansible') {
            steps {
                sshagent([GIT_CREDENTIALS_ID]) {
                    sh 'ansible-playbook -i ansible/inventory ansible/playbook.yml'
                }
            }
        }
    }
}
