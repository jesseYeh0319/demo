properties([
  pipelineTriggers([
    [$class: 'GenericTrigger',
      token: 'github-actions-token',
      genericVariables: [
        [key: 'from', value: '$.from'],
        [key: 'branch', value: '$.branch']
      ],
      causeString: 'Triggered from GitHub Actions',
      printContributedVariables: true
    ]
  ])
])

pipeline {
  agent any

  stages {
    stage('Deploy') {
      steps {
        echo "🚀 接收到 GitHub Actions 來的 webhook！"
        echo "分支名稱：${env.branch}"
      }
    }
  }

  post {
    success {
      echo "✅ 部署成功，已回報"
    }
    failure {
      echo "❌ 部署失敗，請檢查 log"
    }
  }
}

