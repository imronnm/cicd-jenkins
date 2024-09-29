pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                script {
                    // Install Docker if not already installed (if using a clean agent)
                    sh 'apt-get update && apt-get install -y docker.io'
                    // Login to Docker Hub
                    sh 'echo "$DOCKER_HUB_PASSWD" | docker login -u "$DOCKER_HUB_USERNAME" --password-stdin || true'
                    // Build and push the Docker image
                    sh 'docker build -t imronnm/frontendgitlab:latest .'
                    sh 'docker push imronnm/frontendgitlab:latest'
                }
            }
            post {
                success {
                    // Send notification to Discord
                    sh """
                    wget --spider --header="Content-Type: application/json" \
                    --post-data='{"content": "Build Done✅! Deployment is starting."}' \
                    ${DISCORD_WEBHOOK} || echo "Failed to send notification"
                    """
                }
                cleanup {
                    sh 'docker image prune -af'
                }
            }
        }

        stage('Deploy Staging') {
            steps {
                script {
                    // SSH into the server and run the deployment commands
                    sh """
                    echo "$SSH_KEY" > id_rsa
                    chmod 600 id_rsa
                    ssh -i id_rsa -o StrictHostKeyChecking=no $SSH_USER ' 
                        set -e
                        docker compose -f ~/frontend/docker-compose.yml down || echo "Failed to stop containers"
                        docker pull imronnm/frontendgitlab:latest || echo "Failed to pull image"
                        docker compose -f ~/frontend/docker-compose.yml up -d || echo "Failed to start containers"
                    '
                    rm id_rsa
                    """
                }
            }
            post {
                success {
                    // Send notification to Discord
                    sh """
                    wget --spider --header="Content-Type: application/json" \
                    --post-data='{"content": "🚀 *Deploy Staging Sukses!!🔥"}' \
                    ${DISCORD_WEBHOOK} || echo "Failed to send notification"
                    """
                    // Check the staging site
                    sh 'wget --spider -r -nd -nv -l 2 https://team1.studentdumbways.my.id/ || echo "Some pages might be unreachable"'
                }
                cleanup {
                    sh 'docker image prune -af'
                }
            }
            when {
                branch 'staging'
            }
        }

        stage('Deploy Production') {
            steps {
                script {
                    // SSH into the server and run the deployment commands
                    sh """
                    echo "$SSH_KEY" > id_rsa
                    chmod 600 id_rsa
                    ssh -i id_rsa -o StrictHostKeyChecking=no $SSH_USER ' 
                        set -e
                        docker compose -f ~/frontend/docker-compose.yml down || echo "Failed to stop containers"
                        docker pull imronnm/frontendgitlab:latest || echo "Failed to pull image"
                        docker compose -f ~/frontend/docker-compose.yml up -d || echo "Failed to start containers"
                    '
                    rm id_rsa
                    """
                }
            }
            post {
                success {
                    // Send notification to Discord
                    sh """
                    wget --spider --header="Content-Type: application/json" \
                    --post-data='{"content": "🚀 *Deploy Production Sukses!!🔥 Aplikasi kita udah live di production! Cek deh! 👀."}' \
                    ${DISCORD_WEBHOOK} || echo "Failed to send notification"
                    """
                    // Check the production site
                    sh 'wget --spider -r -nd -nv -l 2 https://team1.studentdumbways.my.id/ || echo "Some pages might be unreachable"'
                }
                cleanup {
                    sh 'docker image prune -af'
                }
            }
            when {
                branch 'main'
            }
        }
    }
}
