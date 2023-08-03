pipeline {
    agent none
    stages {
        dir(terraform)
        stage('terraform init') {
            agent any
            options {
                // Timeout counter starts BEFORE agent is allocated
                timeout(time: 1, unit: 'SECONDS')
            }
            steps {
                echo 'Hello World'
                echo 'testin'
            }
        }
    }
}