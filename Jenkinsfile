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
    stage('取得版本資訊') {
      steps {
        script {
          COMMIT_HASH = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
          BUILD_TIME_TAG = "build-${env.BUILD_NUMBER}"
          LATEST_TAG = "${IMAGE_REPO}:latest"
          DEV_TAG = "${IMAGE_REPO}:dev"
          HASH_TAG = "${IMAGE_REPO}:${COMMIT_HASH}"
          BUILD_TAG = "${IMAGE_REPO}:${BUILD_TIME_TAG}"
        }
      }
    }

    stage('建構映像') {
      steps {
        sh './mvnw clean package -DskipTests'
        sh 'docker build -t $LATEST_TAG .'
        sh 'docker tag $LATEST_TAG $DEV_TAG'
        sh 'docker tag $LATEST_TAG $HASH_TAG'
        sh 'docker tag $LATEST_TAG $BUILD_TAG'
      }
    }


    stage('登入並推送') {
      steps {
        withCredentials([
          usernamePassword(credentialsId: "$DOCKERHUB_CREDENTIALS", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')
        ]) {
          sh 'echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin'
        }

        sh 'docker push $LATEST_TAG'
        sh 'docker push $DEV_TAG'
        sh 'docker push $HASH_TAG'
        sh 'docker push $BUILD_TAG'
      }
    }
  }
   
  }
  

  post {
    success {
       echo '✅ 所有 tag 已成功推送'
    }
  }
}

