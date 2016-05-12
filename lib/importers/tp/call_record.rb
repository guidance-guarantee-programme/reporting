module Importers
  module TP
    class CallRecord
      DELIVERY_PARTNER = 'TP'.freeze

      def initialize(row)
        @row = row
      end

      def params
        {
          uid: uid,
          given_at: given_at,
          heard_from_raw: heard_from_raw,
          heard_from_code: heard_from_code,
          pension_provider_code: pension_provider_code,
          location: location,
          delivery_partner: DELIVERY_PARTNER
        }
      end

      def uid
        md5 = Digest::MD5.new
        @row[0..13].each { |cell| md5 << cell&.value.to_s }
        md5.hexdigest
      end

      def date
        value = @row[0]&.value
        value.respond_to?(:utc) && value.utc.to_date
      end

      def given_at
        Time.zone.parse(@row[0].value.strftime('%Y-%m-%d ') + @row[2].value)
      end

      def heard_from_raw
        @row[13]&.value.to_s
      end

      def heard_from_code
        @row[12]&.value.to_s
      end

      def location
        @row[9]&.value.to_s
      end

      def pension_provider_code
        @row[10]&.value.to_s
      end

      def outcome
        @row[8]&.value
      end

      def valid?
        outcome.present? && date && outcome.to_s !~ /test/i
      end

      def self.build(io)
        begin
          workbook = RubyXL::Parser.parse_buffer(io)
        rescue => e
          Bugsnag.notify(e)
          return nil
        end
        workbook['Call Details'].map do |row|
          new(row.cells.to_a)
        end
      end
    end
  end
end
