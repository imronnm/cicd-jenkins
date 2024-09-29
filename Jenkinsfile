pipeline {
    agent any
    
    environment {
        DISCORD_WEBHOOK = "https://discord.com/api/webhooks/1288738076243263511/tF3j9enIM27eZB_NVfv_0gtXpcGm13PrYgbObobY9jDMdhZk9Z_JNHENTpA_4G9dFwJH"
        DOCKER_IMAGE = "imronnm/frontendgitlab"
        TAG = "${env.GIT_BRANCH == 'staging' ? 'staging' : 'latest'}"
    }

    stages {
        stage('Checkout') {
            steps {
                sshagent(['SSH_KEY']) {
                    sh '''
                    git clone https://github.com/imronnm/cicd-jenkins.git
                    cd cicd-jenkins
                    git checkout ${env.GIT_BRANCH}
                    '''
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    sh '''
                    docker build -t ${DOCKER_IMAGE}:${TAG} .
                    docker push ${DOCKER_IMAGE}:${TAG}
                    '''
                }
            }
            post {
                success {
                    script {
                        sh '''
                        wget --spider --header="Content-Type: application/json" \
                        --post-data='{"content": "Build Done✅! Deployment is starting."}' \
                        $DISCORD_WEBHOOK || echo "Failed to send notification"
                        '''
                    }
                }
                cleanup {
                    sh 'docker image prune -af'
                }
            }
        }

        stage('Deploy Staging') {
            steps {
                sshagent(['SSH_KEY']) {
                    sh '''
                    ssh -o StrictHostKeyChecking=no $SSH_USER '
                        set -e
                        cd ~/frontend
                        docker compose -f docker-compose.yml down || echo "Failed to stop containers"
                        docker pull ${DOCKER_IMAGE}:${TAG} || echo "Failed to pull image"
                        docker compose -f docker-compose.yml up -d || echo "Failed to start containers"
                    '
                    '''
                }
            }
            post {
                success {
                    script {
                        sh '''
                        wget --spider --header="Content-Type: application/json" \
                        --post-data='{"content": "🚀 *Deploy Staging Sukses!!🔥"}' \
                        $DISCORD_WEBHOOK || echo "Failed to send notification"
                        '''
                    }
                }
                cleanup {
                    sh 'docker image prune -af'
                }
            }
        }

        stage('Deploy Production') {
            when {
                branch 'main'
            }
            steps {
                sshagent(['SSH_KEY']) {
                    sh '''
                    ssh -o StrictHostKeyChecking=no $SSH_USER '
                        set -e
                        cd ~/frontend
                        docker compose -f docker-compose.yml down || echo "Failed to stop containers"
                        docker pull ${DOCKER_IMAGE}:${TAG} || echo "Failed to pull image"
                        docker compose -f docker-compose.yml up -d || echo "Failed to start containers"
                    '
                    '''
                }
            }
            post {
                success {
                    script {
                        sh '''
                        wget --spider --header="Content-Type: application/json" \
                        --post-data='{"content": "🚀 *Deploy Production Sukses!!🔥 Aplikasi kita udah live di production! Cek deh! 👀."}' \
                        $DISCORD_WEBHOOK || echo "Failed to send notification"
                        '''
                    }
                }
                cleanup {
                    sh 'docker image prune -af'
                }
            }
        }
    }
}
