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

stage('產出 changelog') {
  steps {
	    echo '產出 changelog...'
    sh 'git log -n 10 --pretty=format:"* %s (%an) [%h]" > CHANGELOG.md'
    archiveArtifacts artifacts: 'CHANGELOG.md', fingerprint: true
  }
}
    stage('打包專案') {
      steps {
        sh './mvnw clean package -DskipTests'
      }
    }

stage('標記版本') {
  steps {
    echo '標記版本...'
    script {
      def tag = "v1.0-${env.BUILD_NUMBER}"

withCredentials([usernamePassword(credentialsId: 'github-creds', usernameVariable: 'GIT_USER', passwordVariable: 'GIT_TOKEN')]) {
  echo "GIT_USER = ${GIT_USER}"
  echo "GIT_TOKEN = ****** (masked)"
}
    }
  }
}

stage('Archive JAR') {
  steps {
	  echo 'Archive JAR...'
    archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
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
  	"text": ":white_check_mark: Job: ${env.JOB_NAME} #${env.BUILD_NUMBER} 成功 🎉\\n👉 ${env.BUILD_URL}"
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

