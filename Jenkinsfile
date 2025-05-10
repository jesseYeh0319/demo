@Library('my-shared-lib') _

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
        sh '''
          export LANG=en_US.UTF-8
          export LC_ALL=en_US.UTF-8
          git log -n 10 --pretty=format:"* %s (%an) [%h]" | iconv -f UTF-8 -t UTF-8 > CHANGELOG.md
        '''
        archiveArtifacts artifacts: 'CHANGELOG.md', fingerprint: true
      }
    }

    stage('打包專案') {
      steps {
        sh './mvnw clean package -DskipTests'
      }
    }

    stage('部署前審核') {
      steps {
        script {
          timeout(time: 30, unit: 'MINUTES') {
            input message: '主管請審核', submitter: 'admin,dev-lead'
          }
        }
      }
    }

    stage('部署確認') {
      steps {
        script {
          def result = input(
            id: 'ApprovalInput',
            message: '請選擇要部署的環境',
            parameters: [
              choice(name: 'ENV', choices: ['staging', 'production'], description: '請選擇部署環境'),
              string(name: 'REASON', defaultValue: '例行部署', description: '請填寫說明')
            ]
          )
    
          def targetEnv = result['ENV']
          def reason = result['REASON']
    
          echo "選擇環境：${targetEnv}"
          echo "說明內容：${reason}"
        }
      }
    }


    stage('標記版本') {
      steps {
        echo '標記版本...'
        script {
          sh 'git remote -v'
          sh 'git status'
          def tag = "v1.0-${env.BUILD_NUMBER}"
          withCredentials([usernamePassword(credentialsId: 'github-creds', usernameVariable: 'GIT_USER', passwordVariable: 'GIT_TOKEN')]) {
            sh 'git config user.email "yehjesse96@gmail.com"'
            sh 'git config user.name "jenkins-bot"'
            sh "git remote set-url origin https://${GIT_USER}:${GIT_TOKEN}@github.com/jesseYeh0319/demo.git"
            sh "git tag ${tag}"
            sh "git push origin ${tag}"
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
        notifySlack("Build 成功", ":white_check_mark:")
      }
    }
    failure {
      script {
        notifySlack("Build 失敗，請立即檢查 Log ⚠️", ":x:")
      }
    }
  }
}

