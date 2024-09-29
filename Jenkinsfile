pipeline {
    agent any
    
    stages {
        stage('Build') {
            steps {
                script {
                    // Mendapatkan credential Discord webhook
                    def discordWebhook = credentials('DISCORD_WEBHOOK')
                    
                    // Mendapatkan credential SSH
                    def sshKey = credentials('SSH_KEY')
                    def sshUser = credentials('SSH_USER') // Pastikan juga menambahkan credential untuk user SSH

                    // Menyimpan kunci SSH ke file sementara
                    writeFile(file: 'id_rsa', text: sshKey)
                    sh 'chmod 600 id_rsa'
                    
                    // Mengirim notifikasi ke Discord
                    sh """
                    wget --spider --header="Content-Type: application/json" \
                    --post-data='{"content": "Build Started..."}' \
                    $discordWebhook || echo "Failed to send notification"
                    """

                    // Melakukan SSH ke server dan menjalankan perintah
                    sh """
                    ssh -i id_rsa -o StrictHostKeyChecking=no $sshUser ' 
                        # Perintah yang ingin dijalankan di server
                        echo "SSH connection successful"
                    '
                    """

                    // Menghapus file kunci SSH sementara
                    sh 'rm id_rsa'
                }
            }
        }
    }
    
    post {
        always {
            // Menghapus image Docker yang tidak terpakai
            sh 'docker image prune -af'
        }
    }
}
