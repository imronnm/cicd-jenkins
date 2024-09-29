def secret = 'SSH_KEY'
def vmapps = 'team1@34.143.177.29'
def dir = '~/team1-backend/backend'
def branch = env.GIT_BRANCH // Mendapatkan nama branch
def tag = (branch == 'staging') ? 'staging' : 'latest' // Menentukan tag berdasarkan branch
def images = 'imronnm/backendjenkins'
def discordWebhookUrl = 'https://discord.com/api/webhooks/1288738076243263511/tF3j9enIM27eZB_NVfv_0gtXpcGm13PrYgbObobY9jDMdhZk9Z_JNHENTpA_4G9dFwJH'

pipeline {
    agent any
    stages {
        stage ("Checkout") {
            steps {
                sshagent([secret]) {
                    sh """
                    git clone https://github.com/imronnm/cicd-jenkins.git
                    cd cicd-jenkins
                    git checkout ${branch}
                    """
                }
            }
        }
        stage ("Build Docker Image") {
            steps {
                sshagent([secret]) {
                    sh """
                    ssh -o StrictHostKeyChecking=no ${vmapps} << EOF
                    cd ${dir}
                    docker build -t ${images}:${tag} .
                    exit
                    EOF
                    """
                }
            }
        }
stage ("Deploy") {
    steps {
        sshagent([secret]) {
            sh """
            ssh -o StrictHostKeyChecking=no ${vmapps} << EOF
            cd ${dir}
            docker stop app_name || true
            docker rm app_name || true
            docker run -d --name app_name -p 80:80 ${images}:${tag}
            exit
            EOF
            """
        }

        // Mengirim notifikasi ke Discord
        script {
            def discordWebhookUrl = 'https://discord.com/api/webhooks/1288738076243263511/tF3j9enIM27eZB_NVfv_0gtXpcGm13PrYgbObobY9jDMdhZk9Z_JNHENTpA_4G9dFwJH'
            def message = "Deploy ke ${branch} berhasil! Gambar Docker: ${images}:${tag}"

            sh """
            curl -X POST -H 'Content-Type: application/json' -d '{"content": "${message}"}' ${discordWebhookUrl}
            """
        }
    }
}
