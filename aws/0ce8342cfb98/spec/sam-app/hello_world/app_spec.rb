require './sam-app/hello_world/app'
require 'aws-sdk-s3'

RSpec.describe 'hello_world의 app.rb' do
  describe '#my_func' do
    context '테스트 대역을 사용하지 않는다' do
      it 'AWS SDK 호출 부분에서 exception 발생' do
        expect { my_func }.to raise_error(Aws::Errors::MissingCredentialsError)
      end
    end

    context '테스트 대역을 사용한다' do
      it 'AWS SDK 호출 부분에서 exception이 발생하지 않는다' do
        s3_mock = spy(Aws::S3::Client)
        allow(Aws::S3::Client).to receive(:new).and_return(s3_mock)
        my_func
        expect(s3_mock).to have_received(:list_buckets)
      end
    end

    context 'ENV 테스트 대역을 사용한다' do
      it 'fetch를 사용하는 경우의 stub' do
        allow(ENV).to receive(:fetch).with('MY_BUCKET_NAME', 'ss').and_return('XXX')
        expect(bucket_name_by_fetch).to eq('XXX')
      end
      it 'fetch 없이 사용하는 경우의 stub' do
        allow(ENV).to receive(:[]).with('MY_BUCKET_NAME').and_return('XXX')
        expect(bucket_name_by_without_fetch).to eq('XXX')
      end
    end
  end
end