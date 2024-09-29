pipeline {
    agent any
    environment {
        DOCKER_DRIVER = 'overlay2'
        DISCORD_WEBHOOK = credentials('DISCORD_WEBHOOK')
        DOCKER_HUB_PASSWD = credentials('DOCKER_HUB_PASSWD')
        SSH_KEY = credentials('SSH_KEY')
        SSH_USER = credentials('SSH_USER')
        DOCKER_HUB_USERNAME = 'imronnm' // Assuming your Docker Hub username is fixed
    }
    
    stages {
        stage('Build') {
            steps {
                script {
                    // Login to Docker Hub
                    sh 'echo "$DOCKER_HUB_PASSWD" | docker login -u "$DOCKER_HUB_USERNAME" --password-stdin || true'
                    
                    // Build the Docker image
                    sh 'docker build -t imronnm/frontendgitlab:latest .'
                    
                    // Push the Docker image
                    sh 'docker push imronnm/frontendgitlab:latest'
                    
                    // Send Discord notification for build completion
                    sh '''
                    wget --spider --header="Content-Type: application/json" \
                    --post-data='{"content": "Build Done✅! Deployment is starting."}' \
                    $DISCORD_WEBHOOK || echo "Failed to send notification"
                    '''
                }
            }
        }
        
        stage('Deploy Staging') {
            when {
                branch 'staging'
            }
            steps {
                script {
                    // Create a temporary SSH key file
                    writeFile(file: 'id_rsa', text: "$SSH_KEY")
                    sh 'chmod 600 id_rsa'
                    
                    // SSH into the server and deploy
                    sh '''
                    ssh -i id_rsa -o StrictHostKeyChecking=no $SSH_USER '
                        set -e
                        docker compose -f ~/frontend/docker-compose.yml down || echo "Failed to stop containers"
                        docker pull imronnm/frontendgitlab:latest || echo "Failed to pull image"
                        docker compose -f ~/frontend/docker-compose.yml up -d || echo "Failed to start containers"
                    '
                    '''
                    
                    // Remove the temporary SSH key file
                    sh 'rm id_rsa'
                    
                    // Send Discord notification for staging deployment
                    sh '''
                    wget --spider --header="Content-Type: application/json" \
                    --post-data='{"content": "🚀 *Deploy Staging Sukses!!🔥"}' \
                    $DISCORD_WEBHOOK || echo "Failed to send notification"
                    '''

                    // Check the staging domain
                    sh '''
                    wget --spider -r -nd -nv -l 2 https://team1.studentdumbways.my.id/ || echo "Some pages might be unreachable"
                    '''
                }
            }
        }
        
        stage('Deploy Production') {
            when {
                branch 'main'
            }
            steps {
                script {
                    // Create a temporary SSH key file
                    writeFile(file: 'id_rsa', text: "$SSH_KEY")
                    sh 'chmod 600 id_rsa'
                    
                    // SSH into the server and deploy
                    sh '''
                    ssh -i id_rsa -o StrictHostKeyChecking=no $SSH_USER '
                        set -e
                        docker compose -f ~/frontend/docker-compose.yml down || echo "Failed to stop containers"
                        docker pull imronnm/frontendgitlab:latest || echo "Failed to pull image"
                        docker compose -f ~/frontend/docker-compose.yml up -d || echo "Failed to start containers"
                    '
                    '''
                    
                    // Remove the temporary SSH key file
                    sh 'rm id_rsa'
                    
                    // Send Discord notification for production deployment
                    sh '''
                    wget --spider --header="Content-Type: application/json" \
                    --post-data='{"content": "🚀 *Deploy Production Sukses!!🔥 Aplikasi kita udah live di production! Cek deh! 👀."}' \
                    $DISCORD_WEBHOOK || echo "Failed to send notification"
                    '''

                    // Check the production domain
                    sh '''
                    wget --spider -r -nd -nv -l 2 https://team1.studentdumbways.my.id/ || echo "Some pages might be unreachable"
                    '''
                }
            }
        }
    }
    
    post {
        always {
            // Clean up Docker images
            sh 'docker image prune -af'
        }
    }
}
