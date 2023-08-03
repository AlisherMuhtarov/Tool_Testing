pipeline {
    agent any
    stages {
        stage('terraform init') {
            steps {
                // Change to the desired directory
                dir('terraform') {
                    // Run your commands in the specified directory
                    sh 'terraform init'
                    // Add more commands if needed
                }
            }
        }
        stage('terraform plan') {
            steps {
                // Change to the desired directory
                dir('terraform') {
                    // Run your commands in the specified directory
                    sh 'terraform plan'
                    // Add more commands if needed
                }
            }
        }
        stage('terraform apply') {
            steps {
                // Change to the desired directory
                dir('terraform') {
                    // Run your commands in the specified directory
                    sh 'terraform apply'
                    // Add more commands if needed
                }
            }
        }
    }
}
