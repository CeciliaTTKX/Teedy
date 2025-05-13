pipeline { 
    agent any 
    environment { 
// define environment variable 
// Jenkins credentials configuration 
        DOCKER_HUB_CREDENTIALS = credentials('1') // Docker Hub credentials ID store in Jenkins 
// Docker Hub Repository's name 
DOCKER_IMAGE = 'Ceciliattkx/teedy-app' // your Docker Hub user name and Repository's name 
        DOCKER_TAG = "${env.BUILD_NUMBER}" // use build number as tag 
    } 
    stages { 
        stage('Build') { 
            steps { 
                checkout scmGit( 
                    branches: [[name: '*/master']],  
                    extensions: [],  
                    userRemoteConfigs: [[url: 'https://github.com/CeciliaTTKX/Teedy.git']] 
                    // your github Repository 
                ) 
                sh 'mvn -B -DskipTests clean package' 
            } 
        } 
// Building Docker images 
        stage('Building image') { 
            steps { 
                script { 
                    // assume Dockerfile locate at root  
                    sh "sudo docker build -t ${env.DOCKER_IMAGE}:${env.DOCKER_TAG} ."
                } 
            } 
        } 
// Uploading Docker images into Docker Hub 
        stage('Upload image') { 
            steps { 
                script { 
                        // sign in Docker Hub 
                        docker.withRegistry('https://hub.docker.com/r/ceciliattkx/teedy-app', '1') { 
                        // 推送镜像
                        sh "sudo docker push ${env.DOCKER_IMAGE}:${env.DOCKER_TAG}"
                        // 可选：标记为latest
                        sh "sudo docker tag ${env.DOCKER_IMAGE}:${env.DOCKER_TAG} ${env.DOCKER_IMAGE}:latest"
                        sh "sudo docker push ${env.DOCKER_IMAGE}:latest"
                    } 
                } 
            } 
        }
    // Running Docker container 
        stage('Run containers') { 
            steps { 
                script { 
                    // 如果存在则停止并删除容器
                    sh "sudo docker stop teedy-container-8081 || true"
                    sh "sudo docker rm teedy-container-8081 || true"
                    // 运行容器
                    sh "sudo docker run --name teedy-container-8081 -d -p 8081:8080 ${env.DOCKER_IMAGE}:${env.DOCKER_TAG}"
                    // 可选：列出所有teedy容器
                    sh "sudo docker ps --filter \"name=teedy-container\""
                } 
            } 
        } 
    }
}