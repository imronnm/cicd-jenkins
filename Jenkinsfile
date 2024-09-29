pipeline {
    agent any

    environment {
        DISCORD_WEBHOOK = credentials('DISCORD_WEBHOOK')
        DOCKER_HUB_PASSWD = credentials('DOCKER_HUB_PASSWD')
        SSH_KEY = credentials('SSH_KEY')
        SSH_USER = credentials('SSH_USER')
    }

    stages {
        stage('Build') {
            steps {
                script {
                    // Login to Docker Hub
                    sh 'echo "$DOCKER_HUB_PASSWD" | docker login -u "$DOCKER_HUB_USERNAME" --password-stdin || true'
                    // Build Docker image
                    sh 'docker build -t imronnm/frontendgitlab:latest .'
                    // Push Docker image to Docker Hub
                    sh 'docker push imronnm/frontendgitlab:latest'
                }
            }
            post {
                success {
                    // Notify Discord on successful build
                    sh """
                        wget --spider --header="Content-Type: application/json" \
                        --post-data='{"content": "Build Done✅! Deployment is starting."}' \
                        $DISCORD_WEBHOOK || echo "Failed to send notification"
                    """
                }
                always {
                    // Clean up Docker images
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
                    // Create SSH key for authentication
                    writeFile file: 'id_rsa', text: "${SSH_KEY}"
                    sh 'chmod 600 id_rsa'
                    // Deploy to staging
                    sh """
                        ssh -i id_rsa -o StrictHostKeyChecking=no $SSH_USER '
                            set -e
                            docker compose -f ~/frontend/docker-compose.yml down || echo "Failed to stop containers"
                            docker pull imronnm/frontendgitlab:latest || echo "Failed to pull image"
                            docker compose -f ~/frontend/docker-compose.yml up -d || echo "Failed to start containers"
                        '
                    """
                    // Remove SSH key
                    sh 'rm id_rsa'
                }
            }
            post {
                success {
                    // Notify Discord on successful staging deployment
                    sh """
                        wget --spider --header="Content-Type: application/json" \
                        --post-data='{"content": "🚀 *Deploy Staging Sukses!!🔥"}' \
                        $DISCORD_WEBHOOK || echo "Failed to send notification"
                    """
                }
                always {
                    // Clean up Docker images
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
                    // Create SSH key for authentication
                    writeFile file: 'id_rsa', text: "${SSH_KEY}"
                    sh 'chmod 600 id_rsa'
                    // Deploy to production
                    sh """
                        ssh -i id_rsa -o StrictHostKeyChecking=no $SSH_USER '
                            set -e
                            docker compose -f ~/frontend/docker-compose.yml down || echo "Failed to stop containers"
                            docker pull imronnm/frontendgitlab:latest || echo "Failed to pull image"
                            docker compose -f ~/frontend/docker-compose.yml up -d || echo "Failed to start containers"
                        '
                    """
                    // Remove SSH key
                    sh 'rm id_rsa'
                }
            }
            post {
                success {
                    // Notify Discord on successful production deployment
                    sh """
                        wget --spider --header="Content-Type: application/json" \
                        --post-data='{"content": "🚀 *Deploy Production Sukses!!🔥 Aplikasi kita udah live di production! Cek deh! 👀."}' \
                        $DISCORD_WEBHOOK || echo "Failed to send notification"
                    """
                }
                always {
                    // Clean up Docker images
                    sh 'docker image prune -af'
                }
            }
        }
    }
}
