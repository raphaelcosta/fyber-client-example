class FyberApi::OffersResponse
  attr_accessor :response, :client

  delegate :success?, to: :response

  def initialize(response,client)
    @response = response
    @client = client
    check_response_integrity
    check_if_response_was_successfull
  end

  def code
    response['code']
  end

  def offers
    response['offers']
  end

  def has_offers?
    code == 'OK'
  end

  def message
    response['message']
  end

  private

  def check_response_integrity
    signature = response.headers["x-sponsorpay-response-signature"]
    verification = Digest::SHA1.hexdigest(response.body + client.api_key)
    if signature != verification
      raise FyberApi::ResponseSignatureIsNotValid, 'Response signature header didn\'t match'
    end
  end

  def check_if_response_was_successfull
    raise FyberApi::ResponseNotSuccessfull, "#{code}: #{message}"
  end
end
