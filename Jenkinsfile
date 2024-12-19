pipeline {
    agent any
    environment {
        GITHUB_BASE_URL = 'https://api.github.com'
        GITHUB_TOKEN = credentials('token')
        PATH = "/opt/flutter/bin:${PATH}"   
    }
    stages {
        stage('Check Flutter Installation') {
            steps {
                echo 'Checking Flutter SDK version...'
                sh 'flutter --version'
            }
        }
        stage('Checkout') {
            steps {
                echo 'Checking out code from GitHub...'
                git branch: 'master', url: 'https://github.com/michael-abdul/flutter_github_api.git'
            }
        }
        stage('Load .env File') {
            steps {
                echo 'Loading .env file from credentials...'
                script {
                    withCredentials([file(credentialsId: 'ENV_CONTENT', variable: 'ENV_FILE')]) {
                        sh 'cp $ENV_FILE .env'
                    }
                }
            }
        }
        stage('Install Dependencies') {
            steps {
                echo 'Installing Flutter dependencies...'
                sh 'flutter pub get'
            }
        }
        stage('Flutter Build for Windows') {
            steps {
                echo 'Building Windows .exe file...'
                sh 'flutter build windows'
            }
        }
        stage('Archive Artifacts') {
            steps {
                echo 'Archiving build artifacts...'
                archiveArtifacts artifacts: 'build/windows/runner/Release/**/*.*', fingerprint: true
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying application to the server...'
            }
        }
    }
    post {
        always {
            echo 'Build completed!'
        }
        success {
            echo 'Build succeeded!'
        }
        failure {
            echo 'Build failed. Please check the logs.'
        }
    }
}
