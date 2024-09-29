pipeline {
    agent any

    environment {
        DISCORD_WEBHOOK = credentials('DISCORD_WEBHOOK')
        DOCKER_HUB_PASSWD = credentials('DOCKER_HUB_PASSWD')
        SSH_KEY = credentials('SSH_KEY')
        SSH_USER = credentials('SSH_USER')
        DOCKER_IMAGE = 'imronnm/backendjenkins:latest' // Ganti dengan nama dan tag image Docker yang sesuai
        DOCKER_REPO = 'imronnm/backendjenkins' // Ganti dengan nama repositori Docker Hub yang sesuai
    }

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/imronnm/cicd-jenkins/' // Ganti dengan URL repositori Git yang sesuai
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build(DOCKER_IMAGE)
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', DOCKER_HUB_PASSWD) {
                        docker.image(DOCKER_IMAGE).push()
                    }
                }
            }
        }

        stage('Deploy to Server') {
            steps {
                sshagent (credentials: ['SSH_KEY']) {
                    sh "ssh ${SSH_USER}@server-ip 'docker pull ${DOCKER_IMAGE} && docker run -d ${DOCKER_IMAGE}'" // Ganti 'server-ip' dengan IP server yang sesuai
                }
            }
        }

        stage('Notify Discord') {
            steps {
                script {
                    def message = "Deployment selesai untuk image: ${DOCKER_IMAGE}"
                    sh "curl -H 'Content-Type: application/json' -d '{\"content\": \"${message}\"}' ${DISCORD_WEBHOOK}"
                }
            }
        }
    }
}
