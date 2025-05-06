pipeline {
    agent any

    parameters {
        string(name: 'USERNAME', defaultValue: 'weiyang', description: '使用者名稱')
        choice(name: 'ENV', choices: ['dev', 'test', 'prod'], description: '部署環境')
        booleanParam(name: 'SKIP_TESTS', defaultValue: true, description: '是否跳過測試階段')
    }

    stages {
        stage('顯示參數') {
            steps {
                echo "USERNAME = ${params.USERNAME}"
                echo "ENV = ${params.ENV}"
                echo "ENABLE_DEBUG = ${params.ENABLE_DEBUG}"
            }
        }

        stage('環境處理') {
            steps {
                script {
                    if (params.ENV == 'prod') {
                        echo '⚠️ 正在部署到正式環境！'
                    } else {
                        echo "部署到 ${params.ENV} 環境中..."
                    }
                }
            }
        }
    }
}
