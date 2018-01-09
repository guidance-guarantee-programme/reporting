require 'csv'

module Importers
  module SmartSurvey
    class CallRecord
      def initialize(row, delivery_partner)
        @row = row
        @delivery_partner = delivery_partner.downcase
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

      alias heard_from_code heard_from_raw

      def location
        @row[8].to_s
      end

      def pension_provider
        ''
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
