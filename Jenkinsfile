pipeline {
      options {
            timeout(time: 5, unit: 'HOURS') // timeout for deploy job, usually takes no longer then 4h.
            timestamps()
      }
      agent any
      stages {
            stage('Init') {
                  steps {
                        echo 'Hi, this is Sohidur Rahman'
                        echo 'We are Starting the Testing'
                  }
            }
            stage('Build') {
                  steps {
                        echo 'Building Sample Maven Project'
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