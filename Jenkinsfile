pipeline {
    agent any
    parameters {
        string(name: 'AMI_NAME', description: 'AMI name to use in data_source.tf')
    }
    environment {
        APPLY_RUN_ONCE = 'no'
    }
    stages {
        stage('terraform init') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                }
            }
        }
        stage('terraform plan') {
            steps {
                dir('terraform') {
                    sh "sed -i 's/ami_requirements.v9/${params.AMI_NAME}/g' data_source.tf"
                    sh 'terraform plan'
                }
            }
        }
        stage('terraform apply') {
            when {
                expression { return env.APPLY_RUN_ONCE == 'no' }
            }
            steps {
                dir('terraform') {
                    sh "sed -i 's/ami_requirements.v9/${params.AMI_NAME}/g' data_source.tf"
                    sh 'terraform apply -auto-approve'
                }
            }
            post {
                success {
                    // If 'terraform apply' is successful, set the APPLY_RUN_ONCE to 'yes'
                    always {
                        script {
                            env.APPLY_RUN_ONCE = 'yes'
                        }
                    }
                }
            }
        }
        stage('terraform taint') {
            steps {
                dir('terraform') {
                    sh 'terraform taint aws_launch_template.app_asg_lc'
                }
            }
        }
    }
}
