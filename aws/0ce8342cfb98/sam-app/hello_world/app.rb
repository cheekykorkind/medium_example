require 'json'
require 'aws-sdk-s3'

def lambda_handler(event:, context:)
  v1 = my_func
  {
    statusCode: 200,
    body: {
      message: 'Hello World!',
    }.to_json
  }
end

def my_func
  client = Aws::S3::Client.new(region: 'ap-northeast-1')
  client.list_buckets({})
end

def bucket_name_by_fetch
  ret = ENV.fetch('MY_BUCKET_NAME', 'ss')
end

def bucket_name_by_without_fetch
  ret = ENV['MY_BUCKET_NAME']
end
