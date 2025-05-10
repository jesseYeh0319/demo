pipeline {
  agent any

  environment {
    IMAGE_NAME = 'yehweiyang/demo:latest'
    DOCKERHUB_CREDENTIALS = 'docker-hub' // Jenkins 認證ID
  }

	

  stages {

    stage('確認目錄') {
	  steps {
	    sh 'pwd && ls -al'
	  }
	}

  stage('檢查環境') {
      steps {
        sh 'java -version'
    	sh './mvnw -version' // ✅ 確保使用 wrapper 版本一致
      }
    }

  stage('打包專案') {
      steps {
        sh './mvnw clean package -DskipTests'
        sh 'ls -lh target/*.jar'
      }
    }

   stage('建構 Docker 映像檔') {
      steps {
        sh 'docker build -t $IMAGE_NAME .'
      }
    }

   stage('登入 Docker Hub') {
      steps {
        withCredentials([usernamePassword(credentialsId: "$DOCKERHUB_CREDENTIALS", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
          sh 'echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin'
        }
      }
    }

stage('推送 Docker 映像檔 _ test123') {
  steps {
    sh 'docker push $IMAGE_NAME'
  }
}


  }
}

