pipeline {
  agent any
  tools {
      terraform 'terraform'
  }
  stages{
    stage('terraform init'){
        steps{
            sh 'terraform init'
        }
    }

    stage('terraform fmt'){
        steps{
            sh 'terraform fmt'
        }
    }

    stage('terraform validate'){
        steps{
            sh 'terraform fmt'
        }
    }

    stage('terraform plan'){
        steps{
            sh 'terraform plan'
        }
    }

    stage('request for approval to apply'){
        steps{
            timeout(activity: true, time: 5){
                input message: 'Needs Approval to Apply', submitter: 'amdim'
            }
        }
    }

    stage('terrafrom action'){
        steps{
            sh 'terraform ${action}  -auto-approve'
        }
    }
  }
}