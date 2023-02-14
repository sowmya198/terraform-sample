pipeline {
    agent any


    stages {
        stage('Checkout') {
            steps {
            checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/sowmya198/terraform-sample.git']]])            

          }
        }
        stage('Init') {
            steps {
                withAWS(credentials: 'demo-credentials', region: 'ap-southeast-1') {
                    sh 'echo "hello KB">hello.txt'
                    s3Upload acl: 'Private', bucket: 'demo-bucket', file: 'hello.txt'
            }
        }
        }
    }
    
}

