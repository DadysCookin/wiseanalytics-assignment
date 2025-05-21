pipeline {
    agent any

    environment {
        IMAGE_NAME = "nashit836/mynginx"
        IMAGE_TAG = "${env.BUILD_NUMBER}"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git credentialsId: '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', url: 'https://github.com/DadysCookin/wiseanalytics-assignment.git', branch: 'develop'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t nginx:latest ."
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                        docker push $IMAGE_NAME:$IMAGE_TAG
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
                    sh '''
                        export KUBECONFIG=$KUBECONFIG
                        kubectl set image deployment/deployment my-container=nashit836/mynginx -n staging
                    '''
                }
            }
        }

    }
}
