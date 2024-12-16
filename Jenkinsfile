pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code from GitHub...'
                git branch: 'master', url: 'https://github.com/michael-abdul/flutter_github_api.git'
            }
        }

        stage('Install Flutter') {
            steps {
                echo 'Installing Flutter for Windows...'
                bat '''
                set PATH=C:\\WINDOWS\\System32;%PATH%
                REM Flutter yuklab olish
                curl -LO https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.10.6-stable.zip
        
                REM Flutter katalogini tozalash agar u allaqachon mavjud bo‘lsa
                rmdir /S /Q flutter

                REM Flutterni arxivdan chiqarish
                powershell -Command "Expand-Archive -Path flutter_windows_3.10.6-stable.zip -DestinationPath . -Force"

                REM Git yo‘lini majburiy tarzda PATH'ga qo‘shish
                set GIT_PATH=C:\\Program Files\\Git\\cmd
                set PATH=%GIT_PATH%;%PATH%

                REM Git'ning ishlayotganligini tekshirish
                git --version

                REM Flutter bin yo‘lini PATH'ga qo‘shish
                set PATH=%PATH%;%cd%\\flutter\\bin

                REM Flutter doctor'ni ishga tushirish
                flutter doctor
                '''
            }
        }

        stage('Run Flutter Tests') {
            steps {
                echo 'Running Flutter tests...'
                bat '''
                REM Git'ning yo‘lini qo‘shish
                set GIT_PATH=C:\\Program Files\\Git\\cmd
                set PATH=%GIT_PATH%;%PATH%

                REM Flutter bin yo‘lini qo‘shish
                set PATH=%PATH%;%cd%\\flutter\\bin
                set PATH=%PATH%;%cd%\\flutter\\bin
                flutter test
                '''
            }
        }
    }
}
