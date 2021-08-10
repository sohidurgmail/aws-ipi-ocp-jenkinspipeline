pipeline {
  options {
    ansiColor('xterm')
    timeout(time: 5, unit: 'HOURS') // timeout for deploy job, usually takes no longer then 4h.
    timestamps()
  }
  agent any
  stages {
    stage('Load shared libs from local repo') {
      steps {
        echo "Loading shared libs...."
        }
      }
    }
    stage ('Checkout to repo') {
      steps {
        echo "Checking out repo...."
      }
    }
    stage ('Wipe cluster') {
      when {
        expression { params.DEPLOY_OCP }
      }
      steps {
        script {
            sh(
                script: "aws-ipi/deprovision.sh",
                label: "Wipe a cluster"
            )
        }
      }
    }
    stage ('Deploy OCP') {
      options {
        timeout(time: 2, unit: 'HOURS')   // timeout of deploy ocp
      }
      when {
        environment name: 'DEPLOY_OCP', value: 'true'
      }
      steps {
        wrap([$class: 'BuildUser']) {
          script {
            try {
              sh """
              bash aws-ipi/deploy-cluster.sh
              """
            } catch (err) {
              if (params.DEPROVISION_OCP_ON_FAIL) {
                echo "Failed to deploy OCP, Rolling back (Deprovisioning)"
                echo "!!! THE CLEAN UP IN PROGRESS - DO NOT ABORT THIS BUILD !!!"
                sh "ocp/aws-ipi/deprovision.sh"
                echo "Finished Deprovisioning after OCP Failure"
              }
              throw err
            }
          }
        }
      }
    }
    stage ('Checking OCP Workers Health') {
      when {
        environment name: 'DEPLOY_OCP', value: 'true'
      }
      steps {
          echo "Cluster is healthy...."
      }
    }
  }
}