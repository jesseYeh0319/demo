import groovy.json.JsonOutput

def call(String message, String emoji = ":rocket:") {
  withCredentials([string(credentialsId: 'slack-webhook', variable: 'SLACK_URL')]) {
    def payload = [
      text: "${emoji} Job: ${env.JOB_NAME} #${env.BUILD_NUMBER} ${message}\n👉 ${env.BUILD_URL}"
    ]

    writeFile file: 'slack-payload.json', text: JsonOutput.toJson(payload)

    sh 'curl -X POST -H "Content-type: application/json" --data @slack-payload.json "$SLACK_URL"'
  }
}
