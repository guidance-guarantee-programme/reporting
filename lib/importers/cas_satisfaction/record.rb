require 'csv'

module Importers
  module CasSatisfaction
    class Record
      VALID_SATISFACTION_VALUES = '1'..'5'
      SATISFACTION_MAP = {
        '1' => 4,
        '2' => 3,
        '3' => 2,
        '4' => 1,
        '5' => 0
      }.freeze

      VALID_SMS_VALUES = 0..3

      def initialize(row)
        @row = row
      end

      def params
        {
          uid: uid,
          given_at: given_at,
          satisfaction_raw: satisfaction_raw,
          satisfaction: satisfaction,
          sms_response: sms_response,
          location: '',
          delivery_partner: Partners::CAS_TELEPHONE
        }
      end

      def uid
        @row[0]
      end

      def date
        @row[2]
      end

      def time
        @row[3]
      end

      def given_at
        Time.zone.parse("#{date} #{time}")
      end

      def satisfaction_raw
        @row[4]
      end

      def sms_response
        return unless raw_sms_response = @row[8]

        raw_sms_response.last.to_i
      end

      def satisfaction
        SATISFACTION_MAP[satisfaction_raw.last]
      end

      def valid?
        [uid, date, time, satisfaction_raw, sms_response].all?(&:present?)
      end

      def self.build(io)
        CSV.parse(io.read).tap(&:shift).map { |row| new(row) }
      end
    end
  end
end
