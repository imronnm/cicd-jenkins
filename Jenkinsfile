pipeline {
    agent any

    stages {
        stage('Clone Repository') {
            steps {
                // Cloning the repository dari branch staging
                git branch: 'staging', url: 'https://github.com/imronnm/cicd-jenkins.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                // Build Docker image dan tag sesuai dengan staging
                sh 'docker build -t imronnm/backendjenkins:staging .'
            }
        }

        stage('Push Docker Image to Registry') {
            steps {
                // Push Docker image ke Docker registry
                sh 'docker login -u <docker-username> -p <docker-password>'
                sh 'docker push imronnm/backendjenkins:staging'
            }
        }

        stage('Deploy to Staging') {
            steps {
                // Deploy ke staging VM server menggunakan SSH dan Docker
                sshagent(['your-ssh-credential-id']) {
                    sh '''
                    ssh user@staging-server-ip '
                    docker stop backendjenkins || true &&
                    docker rm backendjenkins || true &&
                    docker pull imronnm/backendjenkins:staging &&
                    docker run -d -p 3000:3000 --name backendjenkins imronnm/backendjenkins:staging
                    '
                    '''
                }
            }
        }
    }

}
