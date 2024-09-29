pipeline {
    agent {
        docker {
            image 'docker:19.03-dind'
            args '--privileged'
        }
    }
    stages {
        stage('Clone Repository') {
            steps {
                // Clone the repository containing your Dockerfile and application code
                git 'https://github.com/imronnm/cicd-jenkins.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                // Build the Docker image
                sh 'docker build -t imronnm/backendjenkins:staging .'
            }
        }
        stage('Push Docker Image to Registry') {
            steps {
                // Authenticate to Docker registry and push the image
                withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    // Login to Docker registry
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    // Push the image to the registry
                    sh 'docker push imronnm/backendjenkins:staging'
                }
            }
        }
        stage('Deploy to Staging') {
            steps {
                // Example command to deploy the image to your staging environment
                // You might need to replace this with your actual deployment command
                sh '''
                # Pull the latest image from the registry
                docker pull imronnm/backendjenkins:staging

                # Stop and remove any running containers (if needed)
                docker stop my_staging_container || true
                docker rm my_staging_container || true

                # Run the new container
                docker run -d --name my_staging_container -p 8080:8080 imronnm/backendjenkins:staging
                '''
            }
        }
    }
    post {
        always {
            // Clean up any resources or images if needed
            sh 'docker rmi imronnm/backendjenkins:staging || true'
        }
    }
}
