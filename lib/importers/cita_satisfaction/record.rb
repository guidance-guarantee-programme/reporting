require 'csv'

module Importers
  module CitaSatisfaction
    class Record
      VALID_SMS_VALUES = '1'..'3'
      VALID_SATISFACTION_VALUES = '1'..'5'
      SATISFACTION_MAP = {
        '1' => 4,
        '2' => 3,
        '3' => 2,
        '4' => 1,
        '5' => 0
      }.freeze

      def initialize(cells)
        @cells = cells
      end

      def params
        {
          uid: uid,
          given_at: given_at,
          satisfaction_raw: satisfaction_raw,
          satisfaction: satisfaction,
          sms_response: sms_response,
          location: location,
          delivery_partner: Partners::CITA_TELEPHONE
        }
      end

      def uid
        "cita_telephone:#{raw_uid}"
      end

      def raw_uid
        @cells[18]
      end

      def call_type
        @cells[5]
      end

      def given_at
        Time.zone.parse(@cells[6])
      end

      def satisfaction_raw
        @cells[14]
      end

      def sms_response
        @cells[15]
      end

      def satisfaction
        SATISFACTION_MAP[satisfaction_raw]
      end

      def location
        ''
      end

      def valid?
        return if [raw_uid, given_at, satisfaction, sms_response].any?(&:blank?)

        call_type == 'Survey goodbye'
      end

      def self.build(io:)
        CSV.parse(io.read).tap(&:shift).map { |row| new(row) }
      end
    end
  end
end
