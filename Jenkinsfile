pipeline {
  agent any


 parameters {
    string(name: 'TAG', defaultValue: 'dev', description: '映像檔版本 Tag')
  }
	
   environment {
    IMAGE_REPO = 'yehweiyang/demo'
    DOCKERHUB_CREDENTIALS = 'docker-hub'
  }



	

  stages {
    stage('打包專案') {
      steps {
        sh './mvnw clean package -DskipTests'
      }
    }

    stage('Docker login 並建置映像檔') {
      steps {
        script {
          withCredentials([usernamePassword(
            credentialsId: '$DOCKERHUB_CREDENTIALS',
            usernameVariable: 'DOCKER_USER',
            passwordVariable: 'DOCKER_PASS'
          )]) {
            sh 'echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin'
            sh 'docker build -t $IMAGE_NAME .'
          }
        }
      }
    }


    stage('推送映像檔') {
      steps {
        sh 'docker push $IMAGE_NAME'
      }
    }
   
  }
  

  post {
    always {
      echo '🚧 清理資源中...'
      sh 'docker logout || true'
    }
    success {
      echo '✅ 建置成功，映像檔已上傳 Docker Hub'
    }
    failure {
      echo '❌ 建置失敗，請檢查 log'
    }
  }
}

