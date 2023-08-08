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
                    script{
                        def remoteStateOutput = sh(script: 'terraform output -json', returnStdout: true).trim()
                        def remoteState = new groovy.json.JsonSlurper().parseText(remoteStateOutput)

                        def launchTemplateValue = remoteState['aws_launch_template.app_asg_lc']['value'] // Adjust the keys to match your actual output structure

                        if (launchTemplateValue == "some_value_that_indicates_change_applied") {
                            sh 'terraform apply -auto-approve -target=aws_launch_template.app_asg_lc'
                        } else {
                            sh 'terraform apply -auto-approve'
                        }
                    }
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