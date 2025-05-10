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


   stage('取得 Commit Hash') {
      steps {
        script {
          COMMIT_HASH = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
          IMAGE_TAG = "${IMAGE_REPO}:${COMMIT_HASH}"
          env.IMAGE_TAG = IMAGE_TAG
          echo "🔖 使用映像版本：${IMAGE_TAG}"
        }
      }
    }

    
    stage('打包與推送映像') {
      steps {
        sh './mvnw clean package -DskipTests'
        sh 'docker build -t $IMAGE_TAG .'

        withCredentials([
          usernamePassword(credentialsId: "$DOCKERHUB_CREDENTIALS", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')
        ]) {
          sh 'echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin'
        }

        sh 'docker push $IMAGE_TAG'
      }
    }
  }
  

  post {
    success {
      echo '✅ Build & Push 完成：$IMAGE_TAG'
    }
  }
}

