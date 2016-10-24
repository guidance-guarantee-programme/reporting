module Importers
  module TP
    class CallRecord
      def initialize(row)
        @row = row
      end

      def wdyh_params
        {
          uid: uid,
          given_at: given_at,
          heard_from_raw: heard_from_raw,
          heard_from_code: heard_from_code,
          pension_provider_code: pension_provider_code,
          location: location,
          delivery_partner: Partners::CONTACT_CENTRE,
          raw_uid: raw_uid
        }
      end

      def call_params
        {
          uid: uid,
          called_at: given_at,
          outcome: outcome,
          third_party_referring: third_party_referring,
          pension_provider: referring_pension_provider,
          call_duration: call_duration
        }
      end

      def uid
        @row['CON_SYSID']&.value || old_uid
      end

      def third_party_referring
        @row['Third Party Referring']&.value.to_s
      end

      def referring_pension_provider
        '' # waiting for TP to add data column to output
      end

      def call_duration
        @row['Call Duration']&.value.to_f.round
      end

      def old_uid
        md5 = Digest::MD5.new
        raw_uid.each { |value| md5 << value }
        md5.hexdigest
      end

      def raw_uid
        @row.values[0..13].map { |cell| fix_number_formatting(cell&.value).to_s }
      end

      def date
        value = @row['Call Date']&.value
        value.respond_to?(:utc) && value.utc.to_date
      end

      def given_at
        Time.zone.parse(@row['Call Date'].value.strftime('%Y-%m-%d ') + @row['Call Start Time'].value)
      end

      def heard_from_raw
        @row['Where Did You Hear Other']&.value.to_s
      end

      def heard_from_code
        @row['Where Did Your Hear']&.value.to_s
      end

      def location
        @row['CAB Office']&.value.to_s
      end

      def pension_provider_code
        @row['Pension Provider']&.value.to_s
      end

      def outcome
        @row['Call Outcome']&.value
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
        header_row = workbook[sheet_name][0].cells.to_a.map(&:value)
        workbook[sheet_name].map do |row|
          new(Hash[header_row.zip(row.cells.to_a)])
        end
      end
    end
  end
end
