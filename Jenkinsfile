def secret = 'SSH_KEY'
def vmapps = 'team1@34.143.177.29'
def dir    = '~/team1-backend/backend$'
def branch = 'master'
           steps {
               sshagent([secret]){
                  sh """ssh -o StrictHostKeyChecking=no ${vmapps} << EOF 
                  cd ${dir}
                  git pull origin ${branch}
                  echo test
                  exit
                  EOF"""
                }
           steps {
               sshagent([secret]){
                  sh """ssh -o StrictHostKeyChecking=no ${vmapps} << EOF 
                  cd ${dir}
                  docker build ${images}:${tag} .
                  echo test
                  exit
                  EOF"""
                }
           steps {
               sshagent([secret]){
                  sh """ssh -o StrictHostKeyChecking=no ${vmapps} << EOF 
                  cd ${dir}
                  docker compose up -d
                  echo test
                  exit
                  EOF"""
                }
            }
        }
    }                           
}
