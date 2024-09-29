pipeline {
    agent any

    stages {
        stage('Clone Repository') {
            steps {
                sshagent(['server-ssh-key']) { // Ganti dengan ID kredensial SSH yang telah dibuat
                    sh 'git clone https://github.com/imronnm/cicd-jenkins.git'
                }
            }
        }

        stage('Pull Changes') {
            steps {
                sshagent(['server-ssh-key']) { // Ganti dengan ID kredensial SSH yang telah dibuat
                    sh 'cd cicd-jenkins && git pull origin master' // Ubah nama folder jika berbeda
                }
            }
        }
    }
}
