pipeline {
  agent any


 parameters {
    string(name: 'TAG', defaultValue: 'dev', description: '映像檔版本 Tag')
  }
	
   environment {
    IMAGE_NAME = 'yehweiyang/demo:latest'
   IMAGE_TAG = "${IMAGE_NAME}:${TAG}"
    DOCKERHUB_CREDENTIALS = 'docker-hub'
  }



	

  stages {


    stage('打包與建構') {
      steps {
        sh './mvnw clean package -DskipTests'
        sh 'docker build -t $IMAGE_TAG .'
      }
    }

    stage('登入並推送') {
      steps {
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
      echo "✅ 映像推送成功：$IMAGE_TAG"
    }
  }
}

