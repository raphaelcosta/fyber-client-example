require 'rails_helper'

describe FyberApi::OffersResponse do
  let(:client) { FyberApi::Client.new }
  let(:body) { '{ "code": "OK", "message": "OK" }' }
  let(:resp) { double("response") }

  before do
    allow(Rails.application.secrets).to receive(:fyber_api_key).and_return('sample_test_api_key')
    allow(resp).to receive_messages(body: body, success?: true, headers: {
      "x-sponsorpay-response-signature" => 'dfaf7887196ca56cf81714b5db39bff74a94eaa6'
    })
  end

  describe '.check_response_integrity' do
    context 'with invalid response signature' do
      before do
        allow(resp).to receive_messages(headers: {
          "x-sponsorpay-response-signature" => '6f8f89108f8f380bb6ad2361ff4ed1e3c53'
        })
      end

      it { expect{FyberApi::OffersResponse.new(resp, client) }.to raise_error(FyberApi::ResponseSignatureIsNotValid) }
    end

    context 'with valid response signature' do
      it { expect{FyberApi::OffersResponse.new(resp, client) }.not_to raise_error }
    end
  end

  describe '.check_if_response_was_successfull' do
    context 'when response code is 200' do
      it { expect{FyberApi::OffersResponse.new(resp, client) }.not_to raise_error }
    end

    context 'when response is not 200' do
      let(:code) { 'ERROR_INVALID_UID' }
      let(:message) { 'An invalid or missing user id (uid) was given as a parameter in the request.' }
      let(:body) { "{ \"code\": \"#{code}\", \"message\": \"#{message}\" }" }
      before do
        allow(resp).to receive_messages(body: body, success?: false, headers: {
          "x-sponsorpay-response-signature" => '70fe20318d7a8c0286690c13bfdda46a33b2fd55',
        })
        allow(resp).to receive(:[]).with('code').and_return(code)
        allow(resp).to receive(:[]).with('message').and_return(message)
      end

      it do
        expect do
          FyberApi::OffersResponse.new(resp, client)
        end.to raise_error(FyberApi::ResponseNotSuccessfull).with_message("#{code}: #{message}")
      end
    end
  end
  
  def sha1_for(value)
    Digest::SHA1.hexdigest(value)
  end
end

