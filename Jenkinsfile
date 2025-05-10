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
            echo "🔁 開始執行測試流程
