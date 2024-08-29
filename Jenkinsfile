// pipeline {
//     agent any

//     environment {
//         AWS_REGION = 'us-west-2'
//         ECR_REPOSITORY = 'jenkins-eks'
//         IMAGE_TAG = "test1"  // Constant image tag
//         ECR_REGISTRY = '300703960986.dkr.ecr.us-west-2.amazonaws.com'
//     }

//     stages {
//         stage('Checkout') {
//             steps {
//                 git branch: 'main', url: 'https://github.com/shreyagangadhar/devops.git'
//             }
//         }

//         stage('Login to ECR') {
//             steps {
//                 script {
//                     sh 'aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REGISTRY'
//                 }
//             }
//         }

//         stage('Docker Build') {
//             steps {
//                 script {
//                     sh 'docker build -t $ECR_REPOSITORY:$IMAGE_TAG .'
//                 }
//             }
//         }

//         stage('Tag Image') {
//             steps {
//                 script {
//                     sh 'docker tag $ECR_REPOSITORY:$IMAGE_TAG $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG'
//                 }
//             }
//         }

//         stage('Push to ECR') {
//             steps {
//                 script {
//                     sh 'docker push $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG'
//                 }
//             }
//         }
//     }

//     post {
//         always {
//             cleanWs()
//         }
//     }
// }


pipeline {
    agent any

    environment {
        AWS_REGION = 'us-west-2'
        ECR_REPOSITORY = 'jenkins-eks'
        IMAGE_TAG = "test1"
        ECR_REGISTRY = '300703960986.dkr.ecr.us-west-2.amazonaws.com'
        PATH = "/var/lib/jenkins/.local/bin:$PATH"
    }

    stages {
        stage('Update SSH Known Hosts') {
            steps {
                script {
                    sh 'ssh-keygen -f "/var/lib/jenkins/.ssh/known_hosts" -R "github.com" || true'
                    sh 'ssh-keyscan github.com >> /var/lib/jenkins/.ssh/known_hosts'
                }
            }
        }

        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/shreyagangadhar/devops.git', credentialsId: 'your-credentials-id'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'pip install --user -r requirements.test.txt'
                sh 'pip install --user coverage'
            }
        }

        stage('Linting') {
            steps {
                script {
                    try {
                        sh 'flake8 .'
                    } catch (Exception e) {
                        echo "Linting failed, but proceeding..."
                    }
                }
            }
        }

        stage('Static Typing') {
            steps {
                script {
                    try {
                        sh 'mypy .'
                    } catch (Exception e) {
                        echo "Static typing failed, but proceeding..."
                    }
                }
            }
        }

        stage('Testing with Coverage') {
            steps {
                script {
                    try {
                        sh 'coverage run -m pytest'
                        sh 'coverage report'
                        sh 'coverage xml -o coverage.xml'  // Generates XML report for integration with CodeCov/Coveralls
                    } catch (Exception e) {
                        echo "Tests or coverage failed, but proceeding..."
                    }
                }
            }
        }

        stage('Database Migrations') {
            steps {
                script {
                    try {
                        sh 'flask db upgrade'
                    } catch (Exception e) {
                        echo "Database migrations failed, but proceeding..."
                    }
                }
            }
        }

        stage('Login to ECR') {
            steps {
                script {
                    sh 'aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REGISTRY'
                }
            }
        }

        stage('Docker Build') {
            steps {
                script {
                    sh 'docker build -t $ECR_REPOSITORY:$IMAGE_TAG .'
                }
            }
        }

        stage('Tag Image') {
            steps {
                script {
                    sh 'docker tag $ECR_REPOSITORY:$IMAGE_TAG $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG'
                }
            }
        }

        stage('Push to ECR') {
            steps {
                script {
                    sh 'docker push $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG'
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
