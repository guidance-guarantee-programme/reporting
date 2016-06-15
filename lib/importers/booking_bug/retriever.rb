require 'faraday'
require 'faraday_middleware'
require 'response_logger'

module Importers
  module BookingBug
    class Retriever
      AUTH_URL = '/api/v1/login'.freeze

      def initialize(config:)
        @config = config
        @auth_token = conn.post(AUTH_URL) do |req|
          req.headers = headers
          req.body = { email: @config.email, password: @config.password }.to_query
        end.body['auth_token']
      end

      def process_records(&block)
        1.upto(Float::INFINITY).each do |index|
          page = get(index)

          page.dig('_embedded', 'bookings').each(&block)

          break unless page.dig('_links', 'next', 'href')
        end
      end

      def get(page_number)
        conn.get("/api/v1/admin/#{@config.company_id}/bookings") do |req|
          req.headers = headers
          req.params.merge!('include_cancelled' => true, 'per_page' => @config.page_size, 'page' => page_number)
          req.params.merge!('modified_since' => modified_since) unless @config.import_all
        end.body
      end

      def modified_since
        Time.zone.yesterday.strftime('%Y-%m-%dT00:00:00')
      end

      def conn
        @conn ||= Faraday.new(url: "https://#{@config.domain}") do |builder|
          builder.use Faraday::Response::RaiseError
          builder.use ResponseLogger, Rails.logger
          builder.use FaradayMiddleware::ParseJson, content_type: /\bjson$/
          builder.adapter Faraday.default_adapter
        end
      end

      def headers
        {
          'App-Id' => @config.app_id,
          'App-Key' => @config.api_key,
          'Auth-Token' => @auth_token
        }.select { |_, v| v.present? }
      end
    end
  end
end
