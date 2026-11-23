pipeline {
    agent any

    environment {
        APP_HOST = 'deploy@192.168.1.3'
        APP_PATH = '/opt/nodeapp'
        SONAR_HOST = 'http://192.168.1.5:9000'
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Obtendo o codigo do repositorio Git'
                checkout scm
            }
        }

        stage('Build') {
            steps {
                echo 'Instalando dependencias e validando a sintaxe'
                sh 'npm install --omit=dev'
                sh 'node --check server.js'
            }
        }

        stage('Test') {
            steps {
                echo 'Executando testes automatizados'
                sh 'npm test'
            }
        }

        stage('SonarQube') {
            steps {
                echo 'Executando analise estatica com SonarQube'
                withCredentials([string(credentialsId: 'sonar-token', variable: 'SONAR_TOKEN')]) {
                    sh 'sonar-scanner -Dsonar.host.url=$SONAR_HOST -Dsonar.login=$SONAR_TOKEN'
                }
            }
        }

        stage('Deploy') {
            steps {
                echo 'Publicando a aplicacao no app01'
                sh '''
                    rsync -az \
                      -e "ssh -o StrictHostKeyChecking=no" \
                      server.js package.json \
                      "$APP_HOST:$APP_PATH/"

                    ssh -o StrictHostKeyChecking=no "$APP_HOST" \
                      "sudo systemctl restart nodeapp.service"
                '''
            }
        }

        stage('Verify') {
            steps {
                echo 'Validando a aplicacao publicada'
                sh 'curl --fail --silent --show-error http://192.168.1.3:3000/health'
            }
        }
    }

    post {
        success {
            echo 'Pipeline executado com sucesso!'
        }
        failure {
            echo 'Pipeline falhou. Verifique os logs.'
        }
    }
}
