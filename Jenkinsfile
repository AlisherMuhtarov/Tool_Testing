pipeline {
    agent any
    stages {
        stage('terraform init') {
            steps {
                // Change to the desired directory
                dir('terraform') {
                    // Run your commands in the specified directory
                    sh 'echo test'
                    // Add more commands if needed
                }
            }
        }
    }
}
