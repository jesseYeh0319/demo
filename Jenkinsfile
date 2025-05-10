@Library('my-shared-lib') _

properties([
  pipelineTriggers([
    [$class: 'GenericTrigger',
      genericVariables: [
        [key: 'COMMENT', value: '$.comment.body'],
        [key: 'PR_NUMBER', value: '$.issue.number']
      ],
      causeString: 'Triggered on comment: $COMMENT',
      token: 'github-pr-comment-token',
      printContributedVariables: true,
      regexpFilterText: '$COMMENT',
      regexpFilterExpression: '^/(retest|deploy)$'
    ]
  ])
])

pipeline {
  agent any

  environment {
    IMAGE_REPO = 'yehweiyang/demo'
    DOCKERHUB_CREDENTIALS = 'docker-hub'
  }

  parameters {
    string(name: 'TAG', defaultValue: 'dev', description: '映像檔版本 Tag')
  }

  stages {
    stage('Triggered by PR comment') {
      steps {
        script {
          def comment = env.COMMENT?.trim()

          echo "👉 PR #${env.PR_NUMBER} 提出指令：${comment}"

          if (comment == "/retest") {
            echo "🔁 開始執行測試流程..."

  sh 'mvn clean verify -DskipITs=false'      // 單元 + 整合測試
  junit 'target/surefire-reports/*.xml'     // 測試結果報告
  archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
          } else if (comment == "/deploy") {
            echo "🚀 執行部署流程中..."
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
