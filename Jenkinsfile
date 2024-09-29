pipeline {
    agent any
    
    stages {
        stage('Build') {
            agent {
                docker {
                    image 'docker:latest'
                    args '-v /var/run/docker.sock:/var/run/docker.sock' // Mount Docker socket
                }
            }
            steps {
                script {
                    // Login to Docker Registry
                    sh 'echo "$DOCKER_HUB_PASSWD" | docker login -u "$DOCKER_HUB_USERNAME" --password-stdin || true'
                    // Build Docker image
                    sh 'docker build -t imronnm/frontendgitlab:latest .'
                    // Push image to Docker Registry
                    sh 'docker push imronnm/frontendgitlab:latest'
                }
            }
            post {
                always {
                    // Clean up unused Docker images
                    sh 'docker image prune -af'
                    // Send notification to Discord
                    sh '''
                        wget --spider --header="Content-Type: application/json" \
                        --post-data='{"content": "Build Done✅! Deployment is starting."}' \
                        $DISCORD_WEBHOOK || echo "Failed to send notification"
                    '''
                }
            }
        }

        stage('Deploy Staging') {
            agent any
            steps {
                script {
                    // Setup SSH key
                    sh 'echo "$SSH_KEY" > id_rsa'
                    sh 'chmod 600 id_rsa'
                    
                    // SSH into server and deploy
                    sh '''
                        ssh -i id_rsa -o StrictHostKeyChecking=no $SSH_USER '
                            set -e
                            docker compose -f ~/frontend/docker-compose.yml down || echo "Failed to stop containers"
                            docker pull imronnm/frontendgitlab:latest || echo "Failed to pull image"
                            docker compose -f ~/frontend/docker-compose.yml up -d || echo "Failed to start containers"
                        '
                    '''
                    
                    // Clean up
                    sh 'rm id_rsa'
                }
            }
            post {
                always {
                    // Clean up unused Docker images
                    sh 'docker image prune -af'
                    // Send notification to Discord
                    sh '''
                        wget --spider --header="Content-Type: application/json" \
                        --post-data='{"content": "🚀 *Deploy Staging Sukses!!🔥"}' \
                        $DISCORD_WEBHOOK || echo "Failed to send notification"
                    '''
                    // Check staging domain
                    sh '''
                        wget --spider -r -nd -nv -l 2 https://team1.studentdumbways.my.id/ || echo "Some pages might be unreachable"
                    '''
                }
            }
            when {
                expression { env.BRANCH_NAME == 'staging' }
            }
        }

        stage('Deploy Production') {
            agent any
            steps {
                script {
                    // Setup SSH key
                    sh 'echo "$SSH_KEY" > id_rsa'
                    sh 'chmod 600 id_rsa'
                    
                    // SSH into server and deploy
                    sh '''
                        ssh -i id_rsa -o StrictHostKeyChecking=no $SSH_USER '
                            set -e
                            docker compose -f ~/frontend/docker-compose.yml down || echo "Failed to stop containers"
                            docker pull imronnm/frontendgitlab:latest || echo "Failed to pull image"
                            docker compose -f ~/frontend/docker-compose.yml up -d || echo "Failed to start containers"
                        '
                    '''
                    
                    // Clean up
                    sh 'rm id_rsa'
                }
            }
            post {
                always {
                    // Clean up unused Docker images
                    sh 'docker image prune -af'
                    // Send notification to Discord
                    sh '''
                        wget --spider --header="Content-Type: application/json" \
                        --post-data='{"content": "🚀 *Deploy Production Sukses!!🔥 Aplikasi kita udah live di production! Cek deh! 👀."}' \
                        $DISCORD_WEBHOOK || echo "Failed to send notification"
                    '''
                    // Check production domain
                    sh '''
                        wget --spider -r -nd -nv -l 2 https://team1.studentdumbways.my.id/ || echo "Some pages might be unreachable"
                    '''
                }
            }
            when {
                expression { env.BRANCH_NAME == 'main' }
            }
        }
    }
    
    environment {
        DOCKER_DRIVER = 'overlay2'
        DISCORD_WEBHOOK = 'https://discord.com/api/webhooks/1288738076243263511/tF3j9enIM27eZB_NVfv_0gtXpcGm13PrYgbObobY9jDMdhZk9Z_JNHENTpA_4G9dFwJH'
    }
}
