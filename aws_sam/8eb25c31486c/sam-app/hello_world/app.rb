require 'json'
require 'faraday'

# event예시
# {
#    "version":"0",
#    "id":"1111111-1111-1111-1111-1111",
#    "detail-type":"CodePipeline Pipeline Execution State Change",
#    "source":"aws.codepipeline",
#    "account":"A_C_C_O_U_N_T_I_D",
#    "time":"2021-07-28T03:55:59Z",
#    "region":"ap-northeast-1",
#    "resources":[
#       "arn:aws:codepipeline:ap-northeast-1:A_C_C_O_U_N_T_I_D:my-awesome-pipeline"
#    ],
#    "detail":{
#       "pipeline":"my-awesome-pipeline",
#       "execution-id":"aaaa-aaaa-aaaa-aaaa-aaaa",
#       "state":"STARTED",
#       "version":1.0
#    }
# }
def lambda_handler(event:, context:)
  state = event.dig('detail', 'state')
  return if state.nil?

  payload = {
    channel: ENV['SLACK_CHANNEL'],
    attachments: [
      {
        text: %w[RESUMED FAILED CANCELED SUPERSEDED].include?(state) ? 'codepipeline실패' : 'codepipeline성공'
      }
    ]
  }

  Faraday.post(ENV['SLACK_WEBHOOK_URL'], payload.to_json, 'Content-Type' => 'application/json')
end
