module Importers
  module TP
    class CallRecord
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
          delivery_partner: DeliveryPartner::TP,
          raw_uid: raw_uid
        }
      end

      def uid
        md5 = Digest::MD5.new
        raw_uid.each { |value| md5 << value }
        md5.hexdigest
      end

      def raw_uid
        @row[0..13].map { |cell| fix_number_formatting(cell&.value).to_s }
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
        date
      end

      # fix bug for non decimal e numbers
      # 500000e-6 should come out formatted as 0.5, however the RubyXL regexp does not recognise this as a number
      # in some formats of the process.
      def fix_number_formatting(value)
        if value.is_a?(String) && value =~ /\A\d+e[+-]\d+\z/
          value.to_f
        else
          value
        end
      end

      def self.build(io:, sheet_name:)
        begin
          workbook = RubyXL::Parser.parse_buffer(io)
        rescue => e
          Bugsnag.notify(e)
          return nil
        end
        workbook[sheet_name].map do |row|
          new(row.cells.to_a)
        end
      end
    end
  end
end
