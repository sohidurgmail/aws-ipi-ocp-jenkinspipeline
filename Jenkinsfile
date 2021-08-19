pipeline {
      options {
            timeout(time: 5, unit: 'HOURS') // timeout for deploy job, usually takes no longer then 4h.
            timestamps()
      }
      agent { label "ocp-aws-ipi-executor" }
      stages {
            stage('Cofigure all the rerequisite') {
                  steps {
                        echo 'Configuring all the prerequisite for deploying the cluster'
                        script {
                              sh(
                                    script: "bash -ex scripts/pre-deploy.sh",
                                    label: "pre deploy"
                              )
                        }
     
                  }
            }
//            stage('Wipe cluster') {
//                  steps {
//                        echo 'Wipe cluster'
//                        script {
//                              sh(
//                                    script: "bash -ex scripts/deprovision.sh",
//                                    label: "Wipe a cluster"
//                              )
//                        }
//     
//                  }
//            }
            stage('Deploy OCP') {
                  options {
                        timeout(time: 2, unit: 'HOURS')   // timeout of deploy ocp
                  }

                  steps {
                        echo 'Deploy OCP'
                        script {
                              sh(
                                    script: "bash -ex scripts/deploy-cluster.sh",
                                    label: "Deploy cluster"
                              )
                        }
                  }
            }

      }
}