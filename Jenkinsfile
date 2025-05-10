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
	      def commitHash = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
	      env.COMMIT_HASH = commitHash
	      env.BUILD_TIME_TAG = "build-${env.BUILD_NUMBER}"
	      env.LATEST_TAG = "${env.IMAGE_REPO}:latest"
	      env.DEV_TAG = "${env.IMAGE_REPO}:dev"
	      env.HASH_TAG = "${env.IMAGE_REPO}:${commitHash}"
	      env.BUILD_TAG = "${env.IMAGE_REPO}:${env.BUILD_TIME_TAG}"
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
  

  post {
    success {
       echo '✅ 所有 tag 已成功推送'
    }
  }
}

