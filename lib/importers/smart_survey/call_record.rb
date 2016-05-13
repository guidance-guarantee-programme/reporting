require 'csv'

module Importers
  module SmartSurvey
    class CallRecord
      HEARD_FROM_CODE_LOOKUP = {
        'Pension Provider' => 'WDYH_PP',
        'Social media' => 'WDYH_SM',
        'Citizens Advice' => 'WDYH_CA',
        'My employer' => 'WDYH_ME',
        'On the internet' => 'WDYH_INT',
        'Financial Adviser' => 'WDYH_FA',
        'Money Advice Service (MAS)' => 'WDYH_MAS',
        'TV advert' => 'WDYH_TV',
        'The Pensions Advisory Service (TPAS)' => 'WDYH_TPAS',
        'Radio advert' => 'WDYH_RA',
        'Newspaper/Magazine advert' => '',
        'Friend/Word of mouth' => 'WDYH_WOM',
        'Local Advertising' => 'WDYH_LA',
        'Job Centre' => 'WDYH_JC',
        'Charity' => 'WDYH_CHA'
      }.freeze
      HEARD_FROM_OTHER = 'WDYH_OTHER'.freeze

      def initialize(row, delivery_partner)
        @row = row
        @delivery_partner = delivery_partner
      end

      def params
        {
          uid: uid,
          given_at: given_at,
          heard_from_raw: heard_from_raw,
          heard_from_code: heard_from_code,
          pension_provider: pension_provider,
          location: location,
          delivery_partner: @delivery_partner
        }
      end

      def uid
        "SS-User:#{user_id}"
      end

      def user_id
        @row[0]
      end

      def given_at
        Time.zone.parse(@row[7])
      end

      def heard_from_raw
        @row[9].to_s
      end

      def heard_from_code
        HEARD_FROM_CODE_LOOKUP.fetch(heard_from_raw, HEARD_FROM_OTHER)
      end

      def location
        @row[8].to_s
      end

      def pension_provider
        @row[10].to_s == '-' ? '' : @row[10].to_s
      end

      def valid?
        user_id.to_i.to_s == user_id
      end

      def self.build(io, delivery_partner)
        rows = CSV.parse(remove_bom(io.read))
        rows.map do |row|
          new(row, delivery_partner)
        end
      end

      def self.remove_bom(str)
        str.force_encoding('utf-8').sub(/^\xEF\xBB\xBF/, '')
      end
    end
  end
end
