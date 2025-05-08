pipeline {
  agent any

  parameters {
    choice(name: 'ENV_FILE', choices: ['.env.dev', '.env.prod'], description: '選擇部署環境')
  }

	

  stages {

    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('使用機密') {
      steps {
	withCredentials([string(credentialsId: 'db-password', variable: 'DB_PASS')]) {
	  sh 'echo 資料庫密碼為：$DB_PASS'
	}
      }
    }
	  
    stage('Build Image') {
      steps {
        dir("${env.WORKSPACE}") {
	  echo '✅ Build Image'
          sh 'docker-compose --env-file ${ENV_FILE} build'
        }
      }
    }

    stage('Stop Existing Containers') {
      steps {
	echo '✅Stop Existing Containers'
        sh 'docker-compose --env-file ${ENV_FILE} down'
      }
    }

    stage('Start Services') {
      steps {
	echo '✅ Start Services'
        sh 'docker-compose --env-file ${ENV_FILE} up -d'
      }
    }
  }
}

