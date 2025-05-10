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

  }
  

  post {
    always {
      echo '🚧 清理資源中...'
      sh 'docker logout || true'
    }
    success {
      script {
      withCredentials([string(credentialsId: 'slack-webhook', variable: 'SLACK_URL')]) {
        sh '''
        curl -X POST -H 'Content-type: application/json' --data '{
          "text": ":white_check_mark: Jenkins 任務成功！🎉"
        }' "$SLACK_URL"
        '''
      }
    }
    }
    failure {
    script {
      withCredentials([string(credentialsId: 'slack-webhook', variable: 'SLACK_URL')]) {
        sh '''
        curl -X POST -H 'Content-type: application/json' --data '{
          "text": ":x: Jenkins 任務失敗！請立即檢查 Log ⚠️"
        }' "$SLACK_URL"
        '''
      }
    }
  }
  }
}

