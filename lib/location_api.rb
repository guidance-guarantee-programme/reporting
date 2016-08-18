require 'open-uri'

class LocationApi
  def initialize(config:)
    @config = config
  end

  def all
    response = open("#{@config.api_uri}/api/v1/twilio_numbers.json", headers_and_options)
    JSON.parse(response.read)
  end

  private

  def headers_and_options
    {}.tap do |hash|
      hash[:read_timeout]   = @config.read_timeout
      hash['Authorization'] = "Bearer #{@config.bearer_token}" if @config.bearer_token
      hash['Accept'] = 'application/json'
    end
  end
end
