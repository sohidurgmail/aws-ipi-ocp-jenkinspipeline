pipeline {
      options {
            timeout(time: 5, unit: 'HOURS') // timeout for deploy job, usually takes no longer then 4h.
            timestamps()
      }
      agent any
      stages {
            stage('Load shared libs from local repo') {
                  steps {
                        echo "library identifier: 'shared-library@thisIsRequieredButIgnored', retriever: legacySCM(scm)"
                  }
            }
            stage('Checkout to automation repo') {
                  steps {
                        echo 'Checkout to automation repo'
                  }
            }
            stage('Wipe cluster') {
                  steps {
                        echo 'Wipe cluster'
                  }
            }
            stage('Deploy OCP') {
                  steps {
                        echo 'Deploy OCP'
                  }
            }
            stage('Checking OCP Workers Health') {
                  steps {
                        echo "Checking OCP Workers Health"
                  }
            }
            stage('Deploy OpenShift Service Mesh') {
                  steps {
                        echo "Deploy OpenShift Service Mesh"
                  }
            }
      }
}