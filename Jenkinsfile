pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                echo 'Obtendo o codigo do repositorio Git'
                checkout scm
            }
        }

        stage('Build') {
            steps {
                echo 'Executando build da aplicacao'
                sh 'python3 -m compileall app-exemplo'
            }
        }

        stage('Test') {
            steps {
                echo 'Executando testes'
                sh 'echo "Testes executados com sucesso"'
            }
        }

        stage('Analise SonarQube') {
            steps {
                echo 'Executando analise estatica com SonarQube'
                // sh 'sonar-scanner -Dsonar.projectKey=app-exemplo -Dsonar.sources=app-exemplo -Dsonar.host.url=http://192.168.1.5:9000'
            }
        }

        stage('Deploy') {
            steps {
                echo 'Executando deploy'
                sh 'echo "Deploy concluido"'
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
