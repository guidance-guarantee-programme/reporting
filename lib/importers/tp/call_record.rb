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
          call_duration: call_duration,
          location: location
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
        @row.values[0..13].map { |cell| format(cell&.value).to_s }
      end

      def date
        value = @row['Call Date']&.value
        value && Date.parse(value.to_s)
      rescue ArgumentError
        false
      end

      def given_at
        Time.zone.parse(date.strftime('%Y-%m-%d ') + @row['Call Start Time'].value)
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

      def format(value)
        if value.is_a?(String) && value =~ /\A\d+e[+-]\d+\z/
          value.to_f
        elsif value.is_a?(DateTime)
          value.to_date
        else
          value
        end
      end

      def self.build(io:)
        begin
          workbook = RubyXL::Parser.parse_buffer(io)
        rescue => e
          Bugsnag.notify(e)
          return nil
        end
        header_row = workbook[0][0].cells.to_a.map(&:value)
        workbook[0].map do |row|
          new(Hash[header_row.zip(row.cells.to_a)])
        end
      end
    end
  end
end
