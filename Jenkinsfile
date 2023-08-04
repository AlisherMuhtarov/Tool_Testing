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
        stage('packer build') {
            steps {
                dir('packer') {
                    script {
                        def packerOutput = sh(script: 'packer build main.pkr.hcl', returnStdout: true)
                        def amiNameMatch = packerOutput =~ /ami_name = "ami_requirements\.(\w+)"/
                        if (amiNameMatch) {
                            env.AMI_NAME = amiNameMatch[0][1]
                            echo "Found AMI name: ${env.AMI_NAME}"
                        }
                    }
                }
            }
        }
        stage('terraform apply') {
            when {
                expression { return env.APPLY_RUN_ONCE == 'no' }
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
        stage('terraform taint') {
            when {
                expression { return env.APPLY_RUN_ONCE == 'yes' }
            }
            steps {
                dir('terraform') {
                    sh 'terraform taint aws_launch_template.app_asg_lc'
                }
            }
        }
    }
}
