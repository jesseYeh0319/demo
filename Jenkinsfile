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

  triggers {
    GenericTrigger(
      genericVariables: [
        [key: 'COMMENT', value: '$.comment.body'],
        [key: 'PR_NUMBER', value: '$.issue.number']
      ],
      causeString: 'Triggered on comment: $COMMENT',
      token: 'github-pr-comment-token',
      printContributedVariables: true,
      regexpFilterText: '$COMMENT',
      regexpFilterExpression: '^/(retest|deploy)$'
    )
  }

  stages {
    stage('Triggered by PR comment') {
      steps {
        script {
          def comment = env.COMMENT?.trim()

          echo "👉 PR #${env.PR_NUMBER} 提出指令：${comment}"

          if (comment == "/retest") {
            echo "🔁 開始執行測試流程..."
            sh './run-tests.sh'
          } else if (comment == "/deploy") {
            echo "🚀 執行部署流程中..."
            sh './deploy-to-staging.sh'
          } else {
            echo "❌ 未支援的指令，跳過執行"
          }
        }
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
