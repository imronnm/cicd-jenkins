def secret = 'general' // Your Jenkins credentials ID for SSH key
def vmapps = 'team1@34.143.177.29' // Your VM SSH user and address
def dir = '/home/team1/frontend' // Your application directory
def branch = 'main' // Branch for deployment
def imageName = 'imronnm/backendjenkins' // Your Docker image name
def tag = 'latest' 

pipeline {
    agent any

    stages {
        stage("Build") {
            steps {
                script {
                    // Build and push the Docker image
                    sh """
                    echo "Building Docker image..."
                    docker build -t ${imageName}:${tag} .
                    docker push ${imageName}:${tag}
                    """
                }
            }
            post {
                success {
                    // Notify on Discord
                    sh """
                    wget --spider --header="Content-Type: application/json" \
                    --post-data='{"content": "Build Done✅! Deployment is starting."}' \
                    $DISCORD_WEBHOOK || echo "Failed to send notification"
                    """
                }
            }
        }

        stage("Deploy Staging") {
            when {
                branch 'staging' // Deploy only on the staging branch
            }
            steps {
                sshagent([secret]) {
                    sh """ssh -o StrictHostKeyChecking=no ${vmapps} << EOF
                    set -e
                    echo "Stopping current containers..."
                    docker compose -f ${dir}/docker-compose.yml down || echo "Failed to stop containers"
                    echo "Pulling latest image..."
                    docker pull ${imageName}:${tag} || echo "Failed to pull image"
                    echo "Starting new containers..."
                    docker compose -f ${dir}/docker-compose.yml up -d || echo "Failed to start containers"
                    EOF"""
                }
            }
            post {
                success {
                    // Notify on Discord
                    sh """
                    wget --spider --header="Content-Type: application/json" \
                    --post-data='{"content": "🚀 *Deploy Staging Sukses!!🔥"}' \
                    $DISCORD_WEBHOOK || echo "Failed to send notification"
                    """
                    // Check staging page
                    sh 'wget --spider -r -nd -nv -l 2 https://team1.studentdumbways.my.id/ || echo "Some pages might be unreachable"'
                }
            }
        }

        stage("Deploy Production") {
            when {
                branch 'main' // Deploy only on the main branch
            }
            steps {
                sshagent([secret]) {
                    sh """ssh -o StrictHostKeyChecking=no ${vmapps} << EOF
                    set -e
                    echo "Stopping current containers..."
                    docker compose -f ${dir}/docker-compose.yml down || echo "Failed to stop containers"
                    echo "Pulling latest image..."
                    docker pull ${imageName}:${tag} || echo "Failed to pull image"
                    echo "Starting new containers..."
                    docker compose -f ${dir}/docker-compose.yml up -d || echo "Failed to start containers"
                    EOF"""
                }
            }
            post {
                success {
                    // Notify on Discord
                    sh """
                    wget --spider --header="Content-Type: application/json" \
                    --post-data='{"content": "🚀 *Deploy Production Sukses!!🔥 Aplikasi kita udah live di production! Cek deh! 👀."}' \
                    $DISCORD_WEBHOOK || echo "Failed to send notification"
                    """
                    // Check production page
                    sh 'wget --spider -r -nd -nv -l 2 https://team1.studentdumbways.my.id/ || echo "Some pages might be unreachable"'
                }
            }
        }
    }

    // Notifications for pipeline completion
    post {
        always {
            echo 'Pipeline has finished.'
        }
    }
}
