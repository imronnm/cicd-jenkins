pipeline {
    agent any // Use any available agent

    stages {
        stage('Build') {
            agent {
                docker {
                    image 'docker:latest' // Specify the Docker image
                    args '-v /var/run/docker.sock:/var/run/docker.sock' // Mount the Docker socket
                }
            }
            steps {
                script {
                    // Authenticate with Docker Hub
                    sh 'echo "$DOCKER_HUB_PASSWD" | docker login -u "$DOCKER_HUB_USERNAME" --password-stdin || true'
                    // Update packages
                    sh 'apt-get update && apt-get install -y wget'
                    // Build and push Docker image
                    sh 'docker build -t imronnm/frontendgitlab:latest .'
                    sh 'docker push imronnm/frontendgitlab:latest'
                    // Notify via Discord
                    sh """
                    wget --spider --header="Content-Type: application/json" \
                    --post-data='{"content": " Build Done✅! Deployment is starting."}' \
                    $DISCORD_WEBHOOK || echo "Failed to send notification"
                    """
                }
            }
        }

        stage('Deploy Staging') {
            agent any
            steps {
                script {
                    // SSH and deployment commands
                    sh 'echo "$SSH_KEY" > id_rsa && chmod 600 id_rsa'
                    sh """
                    ssh -i id_rsa -o StrictHostKeyChecking=no $SSH_USER '
                        set -e
                        docker compose -f ~/frontend/docker-compose.yml down || echo "Failed to stop containers"
                        docker pull imronnm/frontendgitlab:latest || echo "Failed to pull image"
                        docker compose -f ~/frontend/docker-compose.yml up -d || echo "Failed to start containers"
                    '
                    """
                    sh 'rm id_rsa'
                    // Notify via Discord
                    sh """
                    wget --spider --header="Content-Type: application/json" \
                    --post-data='{"content": "🚀 *Deploy Staging Sukses!!🔥"}' \
                    $DISCORD_WEBHOOK || echo "Failed to send notification"
                    wget --spider -r -nd -nv -l 2 https://team1.studentdumbways.my.id/ || echo "Some pages might be unreachable"
                    """
                }
            }
            when {
                branch 'staging'
            }
        }

        stage('Deploy Production') {
            agent any
            steps {
                script {
                    // SSH and deployment commands
                    sh 'echo "$SSH_KEY" > id_rsa && chmod 600 id_rsa'
                    sh """
                    ssh -i id_rsa -o StrictHostKeyChecking=no $SSH_USER '
                        set -e
                        docker compose -f ~/frontend/docker-compose.yml down || echo "Failed to stop containers"
                        docker pull imronnm/frontendgitlab:latest || echo "Failed to pull image"
                        docker compose -f ~/frontend/docker-compose.yml up -d || echo "Failed to start containers"
                    '
                    """
                    sh 'rm id_rsa'
                    // Notify via Discord
                    sh """
                    wget --spider --header="Content-Type: application/json" \
                    --post-data='{"content": "🚀 *Deploy Production Sukses!!🔥 Aplikasi kita udah live di production! Cek deh! 👀."}' \
                    $DISCORD_WEBHOOK || echo "Failed to send notification"
                    wget --spider -r -nd -nv -l 2 https://team1.studentdumbways.my.id/ || echo "Some pages might be unreachable"
                    """
                }
            }
            when {
                branch 'main'
            }
        }
    }
}
