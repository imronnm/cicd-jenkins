pipeline {
    agent any
    
    stages {
        stage('Build') {
            steps {
                script {
                    // Define variables
                    def discordWebhook = 'https://discord.com/api/webhooks/1288738076243263511/tF3j9enIM27eZB_NVfv_0gtXpcGm13PrYgbObobY9jDMdhZk9Z_JNHENTpA_4G9dFwJH'
                    def dockerHubPasswd = 'Beat2023.'
                    def sshKey = '-----BEGIN OPENSSH PRIVATE KEY-----
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
-----END OPENSSH PRIVATE KEY-----
'
                    def sshUser = 'team1@34.143.177.29'
                    def dockerHubUsername = 'imronnm' // Assuming your Docker Hub username is fixed

                    // Login to Docker Hub
                    sh "echo \"$dockerHubPasswd\" | docker login -u \"$dockerHubUsername\" --password-stdin || true"
                    
                    // Build the Docker image
                    sh 'docker build -t imronnm/backendjenkins:latest .'
                    
                    // Push the Docker image
                    sh 'docker push imronnm/backendjenkins:latest'
                    
                    // Send Discord notification for build completion
                    sh """
                    wget --spider --header="Content-Type: application/json" \
                    --post-data='{"content": "Build Done✅! Deployment is starting."}' \
                    $discordWebhook || echo "Failed to send notification"
                    """
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
                    writeFile(file: 'id_rsa', text: "$sshKey")
                    sh 'chmod 600 id_rsa'
                    
                    // SSH into the server and deploy
                    sh """
                    ssh -i id_rsa -o StrictHostKeyChecking=no $sshUser '
                        set -e
                        docker compose -f ~/frontend/docker-compose.yml down || echo "Failed to stop containers"
                        docker pull imronnm/backendjenkins:latest || echo "Failed to pull image"
                        docker compose -f ~/frontend/docker-compose.yml up -d || echo "Failed to start containers"
                    '
                    """
                    
                    // Remove the temporary SSH key file
                    sh 'rm id_rsa'
                    
                    // Send Discord notification for staging deployment
                    sh """
                    wget --spider --header="Content-Type: application/json" \
                    --post-data='{"content": "🚀 *Deploy Staging Sukses!!🔥"}' \
                    $discordWebhook || echo "Failed to send notification"
                    """

                    // Check the staging domain
                    sh """
                    wget --spider -r -nd -nv -l 2 https://team1.studentdumbways.my.id/ || echo "Some pages might be unreachable"
                    """
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
                    writeFile(file: 'id_rsa', text: "$sshKey")
                    sh 'chmod 600 id_rsa'
                    
                    // SSH into the server and deploy
                    sh """
                    ssh -i id_rsa -o StrictHostKeyChecking=no $sshUser '
                        set -e
                        docker compose -f ~/frontend/docker-compose.yml down || echo "Failed to stop containers"
                        docker pull imronnm/backendjenkins:latest || echo "Failed to pull image"
                        docker compose -f ~/frontend/docker-compose.yml up -d || echo "Failed to start containers"
                    '
                    """
                    
                    // Remove the temporary SSH key file
                    sh 'rm id_rsa'
                    
                    // Send Discord notification for production deployment
                    sh """
                    wget --spider --header="Content-Type: application/json" \
                    --post-data='{"content": "🚀 *Deploy Production Sukses!!🔥 Aplikasi kita udah live di production! Cek deh! 👀."}' \
                    $discordWebhook || echo "Failed to send notification"
                    """

                    // Check the production domain
                    sh """
                    wget --spider -r -nd -nv -l 2 https://team1.studentdumbways.my.id/ || echo "Some pages might be unreachable"
                    """
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
