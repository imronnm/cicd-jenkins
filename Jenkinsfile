def secret = 'SSH_KEY'
def vmapps = 'team1@34.143.177.29'
def dir    = '~/team1-backend/backend'
def branch = 'main'
def tag    = 'latest'
def images = 'imronnm/backendjenkins'

pipeline {
    agent any
    stages {
        stage ("Pull from Git") {
            steps {
                sshagent([secret]) {
                    sh """
                    ssh -o StrictHostKeyChecking=no ${vmapps} << EOF
                    cd ${dir}
                    git checkout ${branch}
                    git pull origin ${branch}
                    EOF
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
                    EOF
                    """
                }
            }
        }
        stage ("Run Docker Container") {
            steps {
                sshagent([secret]) {
                    sh """
                    ssh -o StrictHostKeyChecking=no ${vmapps} << EOF
                    cd ${dir}
                    # Stop any existing container if running
                    if [ \$(docker ps -q -f name=${images}) ]; then
                        docker stop ${images}
                        docker rm ${images}
                    fi
                    # Run new container
                    docker run -d --name ${images} -p 5000:5000 ${images}:${tag}
                    EOF
                    """
                }
            }
        }
        stage ("Clean Up") {
            steps {
                sshagent([secret]) {
                    sh """
                    ssh -o StrictHostKeyChecking=no ${vmapps} << EOF
                    # Optionally remove old images
                    docker image prune -f
                    EOF
                    """
                }
            }
        }
    }                           
}
