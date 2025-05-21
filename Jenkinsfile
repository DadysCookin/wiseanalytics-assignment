pipeline {
    agent any

    environment {
        IMAGE_NAME = "nashit836/mynginx"
        IMAGE_TAG = "${env.BUILD_NUMBER}"
        GIT_BRANCH = "develop"  // or "master" as per your repo
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout([$class: 'GitSCM',
                          branches: [[name: "refs/heads/main"]],
                          userRemoteConfigs: [[url: 'https://github.com/DadysCookin/wiseanalytics-assignment.git']]
                ])
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
                        docker push nginx:latest
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
                    sh '''
                        export KUBECONFIG=$KUBECONFIG
                        kubectl set image deployment/deployment mycontainer=nginx:latest -n staging
                    '''
                }
            }
        }
    }
}
