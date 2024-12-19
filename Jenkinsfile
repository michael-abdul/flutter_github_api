pipeline {
    agent any
 environment {
        GITHUB_BASE_URL = 'https://api.github.com'
        GITHUB_TOKEN = credentials('token') // Jenkins Credential ID
    }
    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code from GitHub...'
                git branch: 'master', url: 'https://github.com/michael-abdul/flutter_github_api.git'
            }
        }
        stage('Flutter Clean') {
            steps {
                bat 'flutter clean'
            }
        }
        stage('Install Dependencies') {
            steps {
                bat 'flutter pub get'
            }
        }
        stage('Flutter Build') {
            steps {
                bat 'flutter build windows'
            }
        }
        stage('Archive Artifacts') {
            steps {
                archiveArtifacts artifacts: 'build/windows/runner/Release/**/*.*', fingerprint: true
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deployment send to server'
            }
        }
    }
    post {
        always {
            echo 'Build completed!'
        }
    }
}

