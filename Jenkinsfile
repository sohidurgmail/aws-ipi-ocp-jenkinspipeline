pipeline {
      options {
            timeout(time: 5, unit: 'HOURS') // timeout for deploy job, usually takes no longer then 4h.
            timestamps()
      }
      agent { label "ocp-aws-ipi-executor" }
      stages {
            stage('Load shared libs from local repo') {
                  steps {
                        echo "library identifier: 'shared-library@thisIsRequieredButIgnored', retriever: legacySCM(scm)"
                        //library identifier: 'shared-library@thisIsRequieredButIgnored', retriever: legacySCM(scm)
                  }
            }
//            stage('Checkout to automation repo') {
//                  steps {
//                        echo 'Checkout to automation repo'
//                  }
 //           }
            stage('Cofigure all the rerequisite') {
                  steps {
                        echo 'Configuring all the prerequisite for deploying the cluster'
                        script {
                              sh(
                                    script: "bash -ex pre-deploy.sh",
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
//                                    script: "bash -ex deprovision.sh",
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
                                    script: "bash -ex deploy-cluster.sh",
                                    label: "Deploy cluster"
                              )
                        }
                  }
            }
            stage('Checking OCP Workers Health') {
                  steps {
                        echo "Checking OCP Workers Health"
                  }
            }
            stage('Deploy Safwans computer') {
                  steps {
                        echo "Deploy OpenShift Service Mesh"
                  }
            }
      }
}