class FyberApi::Client
  include HTTParty
  base_uri 'http://api.sponsorpay.com/feed/v1/'
  headers 'Accept-encoding' => 'gzip'

  def initialize(api_key=nil)
    @api_key = api_key
    check_if_api_key_is_present
  end

  # http://developer.fyber.com/content/ios/offer-wall/offer-api/
  def fetch_offers(options = {})
    options.reverse_merge! default_options
    query = options.reverse_merge hashkey: generate_hashkey(options)

    response = self.class.get('/offers.json', query: query)
    FyberApi::OffersResponse.new(response, self)
  end

  def api_key
    @api_key ||= Rails.application.secrets.fyber_api_key
  end

  private

  def generate_hashkey(options)
    ordered_options = Hash[options.sort_by { |k,v| k }]
    query_string = ordered_options.to_query
    query_string += "&#{api_key}"
    Digest::SHA1.hexdigest(query_string)
  end

  def default_options
    {
      appid: 157,
      format: 'json',
      device_id: '2b6f0cc904d137be2e1730235f5664094b831186',
      locale: 'de',
      ip: '109.235.143.113',
      offer_types: '112',
      timestamp: Time.now.to_i
    }
  end

  def check_if_api_key_is_present
    raise FyberApi::MissingAPIKey, 'Please first set Fyber API Key on secrets.yml file' if api_key.blank?
  end
end
