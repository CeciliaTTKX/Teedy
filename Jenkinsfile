pipeline { 
    agent any 
    environment { 
        // 定义环境变量 
        // Jenkins凭证配置 - 暂时注释掉，改用手动登录
        // DOCKER_HUB_CREDENTIALS = credentials('1') 
        
        // Docker Hub仓库名称
        DOCKER_IMAGE = 'ceciliattkx/teedy-app' 
        DOCKER_TAG = "${env.BUILD_NUMBER}" 
    } 
    stages { 
        stage('Build') { 
            steps { 
                checkout scmGit( 
                    branches: [[name: '*/master']],  
                    extensions: [],  
                    userRemoteConfigs: [[url: 'https://github.com/CeciliaTTKX/Teedy.git']] 
                ) 
                sh 'mvn -B -DskipTests clean package' 
            } 
        } 
        
        // 构建Docker镜像
        stage('Building image') { 
            steps { 
                script { 
                    sh "sudo docker build -t ${env.DOCKER_IMAGE}:${env.DOCKER_TAG} ."
                } 
            } 
        } 
        
        // 手动登录Docker Hub
        stage('Manual Docker Login') {
            steps {
                timeout(time: 10, unit: 'MINUTES') {
                    input message: '请在Jenkins服务器上手动登录Docker Hub', ok: '已完成登录，继续执行'
                    sh 'echo "请确保已在Jenkins服务器上执行: docker login"'
                }
            }
        }
        
        // 上传Docker镜像到Docker Hub
        stage('Upload image') { 
            steps { 
                script { 
                    // 移除自动登录，假设用户已手动登录
                    sh "sudo docker push ${env.DOCKER_IMAGE}:${env.DOCKER_TAG}"
                    sh "sudo docker tag ${env.DOCKER_IMAGE}:${env.DOCKER_TAG} ${env.DOCKER_IMAGE}:latest"
                    sh "sudo docker push ${env.DOCKER_IMAGE}:latest"
                } 
            } 
        }
        
        // 运行Docker容器
        stage('Run containers') { 
            steps { 
                script { 
                    sh "sudo docker stop teedy-container-8081 || true"
                    sh "sudo docker rm teedy-container-8081 || true"
                    sh "sudo docker run --name teedy-container-8081 -d -p 8081:8080 ${env.DOCKER_IMAGE}:${env.DOCKER_TAG}"
                    sh "sudo docker ps --filter \"name=teedy-container\""
                } 
            } 
        } 
    }
}
