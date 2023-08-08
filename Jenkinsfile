pipeline {
    agent any
    parameters {
        string(name: 'AMI_NAME', description: 'AMI name to use in data_source.tf')
        booleanParam(name: 'TERRAFORM_DESTROY', defaultValue: false, description: 'Perform Terraform destroy')
    }
    environment {
        APPLY_RUN_ONCE = 'no'
    }
    stages {
        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                }
            }
        }
        stage('terraform plan') {
            when {
                expression { return env.APPLY_RUN_ONCE == 'no' && !params.TERRAFORM_DESTROY }
            }
            steps {
                dir('terraform') {
                    sh "echo ${AMI_NAME}"
                    sh "echo ${env.AMI_NAME}"
                    sh "sed -i 's/ami_requirements.v9/${env.AMI_NAME}/g' data_source.tf"
                    sh 'terraform plan'
                }
            }
        }
        stage('terraform apply') {
            when {
                expression { return env.APPLY_RUN_ONCE == 'no' && !params.TERRAFORM_DESTROY }
            }
            steps {
                dir('terraform') {
                    sh "sed -i 's/ami_requirements.v9/${env.AMI_NAME}/g' data_source.tf"
                    sh 'terraform apply -auto-approve'
                }
            }
            post {
                success {
                    always {
                        script {
                            env.APPLY_RUN_ONCE = 'yes'
                        }
                    }
                }
            }
        }
        stage('Check Previous Build Result and Apply Launch Template') {
            when {
                expression { return env.APPLY_RUN_ONCE == 'yes' && currentBuild.resultIsBetterOrEqualTo('SUCCESS') }
            }
            steps {
                dir('terraform') {
                    sh "sed -i 's/ami_requirements.v9/${env.AMI_NAME}/g' data_source.tf"
                    sh 'terraform apply -auto-approve -target=aws_launch_template'
                }
            }
        }
        stage('terraform apply -target=aws_launch_template') {
            when {
                expression { return env.APPLY_RUN_ONCE == 'yes' && currentBuild.resultIsWorseThan('SUCCESS') }
            }
            steps {
                dir('terraform') {
                    sh "sed -i 's/ami_requirements.v9/${env.AMI_NAME}/g' data_source.tf"
                    sh 'terraform apply -auto-approve -target=aws_launch_template'
                }
            }
        }
        stage('terraform destroy') {
            when {
                expression { return params.TERRAFORM_DESTROY }
            }
            steps {
                dir('terraform') {
                    sh "sed -i 's/ami_requirements.v9/${env.AMI_NAME}/g' data_source.tf"
                    sh 'terraform destroy -auto-approve'
                }
            }
        }
    }
}