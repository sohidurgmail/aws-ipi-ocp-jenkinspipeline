pipeline {
      agent any
      stages {
            stage('Init') {
                  steps {
                        echo 'Hi, this is Sohidur Rahman'
                        echo 'We are Starting the Testing'
                        echo "${AWSKEY}"
                  }
            }
            stage('Build') {
                  steps {
                        echo 'Building Sample Maven Projec'
                  }
            }
            stage('Deploy') {
                  steps {
                        echo "Deploying in Staging Area"
                  }
            }
            stage('Deploy Production') {
                  steps {
                        echo "Deploying in Production Area"
                  }
            }
      }
}
