require "rails_helper"

describe FyberApi::Client do
  describe '#initialize' do
    context 'when fyber api key is not set application secrets' do
      before { Rails.application.secrets.fyber_api_key = nil }
      it { expect{ FyberApi::Client.new }.to raise_error(FyberApi::MissingAPIKey) }
    end

    context 'when fyber api key is set on secrets' do
      before { Rails.application.secrets.fyber_api_key = 'sample_test_api_key' }
      it 'expect to client api key to be equal fyber_api_key secret' do
        expect(subject.api_key).to eq('sample_test_api_key')
      end
    end

    context 'when fyber api key is passed on method' do
      it 'expect to client api key to be the same of method parameter' do
        client = FyberApi::Client.new('api_key_by_parameter')
        expect(client.api_key).to eq('api_key_by_parameter')
      end
    end
  end
end
