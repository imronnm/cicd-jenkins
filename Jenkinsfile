pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                script {
                    // Tambahkan logika build di sini
                    echo 'Building...'
                }
            }
        }
        stage('Deploy') {
            when {
                // Pastikan ini ada di dalam blok `when`
                anyOf {
                    branch 'staging'  // Deploy hanya di cabang staging
                    branch 'main'     // Deploy hanya di cabang main
                }
            }
            steps {
                script {
                    // Tambahkan logika deploy di sini
                    echo 'Deploying...'
                }
            }
        }
    }
}
