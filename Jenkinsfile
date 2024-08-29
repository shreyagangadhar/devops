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
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/shreyagangadhar/devops.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'pip install --user -r requirements.test.txt'
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
                sh 'mypy .'
            }
        }

        stage('Testing') {
            steps {
                sh 'pytest --cov=app'
            }
        }

        stage('Database Migrations') {
            steps {
                sh 'flask db upgrade'
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

        stage('Versioning') {
            steps {
                script {
                    def version = readFile('version.txt').trim()
                    def buildNumber = env.BUILD_NUMBER
                    sh "echo ${version}.${buildNumber} > version.txt"
                    sh "git commit -am 'Incremented version to ${version}.${buildNumber}'"
                    sh "git push"
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
