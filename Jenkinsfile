pipeline {
  agent any

   environment {
    IMAGE_NAME = 'yehweiyang/demo:latest'
    DOCKERHUB_CREDENTIALS = 'docker-hub'
  }
	

  stages {

    stage('確認 Maven Wrapper') {
      steps {
        sh 'ls -l ./mvnw'
        sh './mvnw -version'
      }
    }

    stage('打包專案') {
      steps {
        sh './mvnw clean package -DskipTests'
      }
    }

    stage('建構並推送 Docker 映像檔') {
      steps {
        sh 'docker build -t $IMAGE_NAME .'
        withCredentials([
          usernamePassword(credentialsId: "$DOCKERHUB_CREDENTIALS", usernameVariable: 'DOCKER_USER123', passwordVariable: 'DOCKER_PASS123')
        ]) {
          sh 'echo "$DOCKER_PASS123" | docker login -u "$DOCKER_USER123" --password-stdin'
        }
        sh 'docker push $IMAGE_NAME'
      }
    }
  }

  post {
    success {
      echo '✅ 使用 mvnw 建構與推送完成'
    }
    failure {
      echo '❌ 建構失敗，請檢查錯誤日誌'
    }
  }
}

