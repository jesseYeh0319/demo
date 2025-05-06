pipeline {
    agent any

    parameters {
        string(name: 'USERNAME', defaultValue: 'weiyang', description: '使用者名稱')
        choice(name: 'ENV', choices: ['dev', 'test', 'prod'], description: '部署環境')
        booleanParam(name: 'SKIP_TESTS', defaultValue: true, description: '是否跳過測試階段')
    }

    stages {
        stage('Webhook 驗證') {
            steps {
                withCredentials([string(credentialsId: 'slack-webhook', variable: 'SLACK_URL')]) {
                    sh 'echo "✅ SLACK_URL 已成功取得：$SLACK_URL"'
                }
            }
        }

        stage('顯示參數') {
            steps {
                echo "👤 USERNAME = ${params.USERNAME}"
                echo "🌎 ENV = ${params.ENV}"
                echo "🧪 SKIP_TESTS = ${params.SKIP_TESTS}"
            }
        }

        stage('環境處理') {
            steps {
                script {
                    if (params.ENV == 'prod') {
                        echo '⚠️ 正在部署到正式環境！'
                    } else {
                        echo "🚧 部署到 ${params.ENV} 環境中..."
                    }
                }
            }
        }
    }

    post {
        success {
            echo '✅ 建置成功，發送 Slack 成功通知'
            withCredentials([string(credentialsId: 'slack-webhook', variable: 'SLACK_URL')]) {
                sh 'curl -X POST -H "Content-type: application/json" --data \'{"text":"✅ Jenkins Job 成功完成！"}\' $SLACK_URL'
            }
        }

        failure {
            echo '❌ 建置失敗，發送 Slack 失敗通知'
            withCredentials([string(credentialsId: 'slack-webhook', variable: 'SLACK_URL')]) {
                sh 'curl -X POST -H "Content-type: application/json" --data \'{"text":"❌ Jenkins Job 失敗，請立即查看！"}\' $SLACK_URL'
            }
        }

        always {
            echo '📬 Jenkins Job 完成，進入 post 區塊'
            withCredentials([string(credentialsId: 'slack-webhook', variable: 'SLACK_URL')]) {
                sh 'curl -X POST -H "Content-type: application/json" --data \'{"text":"📬 Jenkins Job 執行完畢（不論成功或失敗）"}\' $SLACK_URL'
            }
        }
    }
}
