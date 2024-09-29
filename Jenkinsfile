pipeline {
    agent any

    environment {
        DOCKER_DRIVER = 'overlay2'
        DISCORD_WEBHOOK = "https://discord.com/api/webhooks/1288738076243263511/tF3j9enIM27eZB_NVfv_0gtXpcGm13PrYgbObobY9jDMdhZk9Z_JNHENTpA_4G9dFwJH"
        DOCKER_HUB_USERNAME = credentials('docker-hub-username') // Ganti dengan ID kredensial Anda
        DOCKER_HUB_PASSWD = credentials('docker-hub-password') // Ganti dengan ID kredensial Anda
        SSH_KEY = credentials('ssh-private-key') // Ganti dengan ID kredensial SSH Anda
        SSH_USER = 'your_ssh_user' // Ganti dengan username SSH Anda
    }

    stages {
        stage('Build') {
            agent {
                docker {
                    image 'docker:latest'
                    args '-u root' // Menjalankan dengan user root
                }
            }
            steps {
                script {
                    // Login ke Docker Hub
                    sh '''
                        echo "$DOCKER_HUB_PASSWD" | docker login -u "$DOCKER_HUB_USERNAME" --password-stdin || true
                    '''
                    // Build dan push Docker image
                    sh '''
                        docker build -t imronnm/frontendgitlab:latest .
                        docker push imronnm/frontendgitlab:latest
                    '''
                }
                // Kirim notifikasi ke Discord
                script {
                    def jsonPayload = '{"content": " Build Done✅! Deployment is starting."}'
                    sh "curl -X POST -H 'Content-Type: application/json' -d '${jsonPayload}' ${DISCORD_WEBHOOK}"
                }
            }
            post {
                always {
                    // Bersihkan image Docker
                    sh 'docker image prune -af'
                }
            }
        }

        stage('Deploy Staging') {
            when {
                branch 'staging'
            }
            steps {
                script {
                    writeFile(file: 'id_rsa', text: "${SSH_KEY}")
                    sh 'chmod 600 id_rsa'
                    sh '''
                        ssh -i id_rsa -o StrictHostKeyChecking=no $SSH_USER '
                            set -e
                            docker-compose -f ~/frontend/docker-compose.yml down || echo "Failed to stop containers"
                            docker pull imronnm/frontendgitlab:latest || echo "Failed to pull image"
                            docker-compose -f ~/frontend/docker-compose.yml up -d || echo "Failed to start containers"
                        '
                    '''
                    sh 'rm id_rsa'
                }
                // Kirim notifikasi ke Discord
                script {
                    def jsonPayload = '{"content": "🚀 *Deploy Staging Sukses!!🔥"}'
                    sh "curl -X POST -H 'Content-Type: application/json' -d '${jsonPayload}' ${DISCORD_WEBHOOK}"
                }
                // Cek halaman di domain staging
                script {
                    sh "curl -s -o /dev/null --head --fail https://team1.studentdumbways.my.id/ || echo 'Some pages might be unreachable'"
                }
            }
            post {
                always {
                    // Bersihkan image Docker
                    sh 'docker image prune -af'
                }
            }
        }

        stage('Deploy Production') {
            when {
                branch 'main'
            }
            steps {
                script {
                    writeFile(file: 'id_rsa', text: "${SSH_KEY}")
                    sh 'chmod 600 id_rsa'
                    sh '''
                        ssh -i id_rsa -o StrictHostKeyChecking=no $SSH_USER '
                            set -e
                            docker-compose -f ~/frontend/docker-compose.yml down || echo "Failed to stop containers"
                            docker pull imronnm/frontendgitlab:latest || echo "Failed to pull image"
                            docker-compose -f ~/frontend/docker-compose.yml up -d || echo "Failed to start containers"
                        '
                    '''
                    sh 'rm id_rsa'
                }
                // Kirim notifikasi ke Discord
                script {
                    def jsonPayload = '{"content": "🚀 *Deploy Production Sukses!!🔥 Aplikasi kita udah live di production! Cek deh! 👀."}'
                    sh "curl -X POST -H 'Content-Type: application/json' -d '${jsonPayload}' ${DISCORD_WEBHOOK}"
                }
                // Cek halaman di domain production
                script {
                    sh "curl -s -o /dev/null --head --fail https://team1.studentdumbways.my.id/ || echo 'Some pages might be unreachable'"
                }
            }
            post {
                always {
                    // Bersihkan image Docker
                    sh 'docker image prune -af'
                }
            }
        }
    }
}
