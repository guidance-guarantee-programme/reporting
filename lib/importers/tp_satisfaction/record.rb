require 'csv'

module Importers
  module TpSatisfaction
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
          delivery_partner: Partners::TP
        }
      end

      def uid
        "tp_satisfaction:#{@cells['URN'].value}"
      end

      def given_at
        Time.zone.parse("#{date} 09:00")
      end

      def satisfaction_raw
        @cells['Q1 Response']&.value.to_s
      end

      def satisfaction
        SATISFACTION_MAP[satisfaction_raw]
      end

      def location
        ''
      end

      def valid?
        return if @cells['URN']&.value.to_s.blank?

        VALID_SATISFACTION_VALUES.cover?(satisfaction_raw) && VALID_SMS_VALUES.cover?(sms_response)
      end

      def sms_response
        @cells['Q2 Response']&.value.to_i
      end

      def date
        @cells['Date']&.value.to_s
      end

      def self.build(io:, sheet_name:)
        begin
          workbook = RubyXL::Parser.parse_buffer(io)
        rescue => e
          Bugsnag.notify(e)
          return nil
        end

        header_row = workbook[sheet_name][0].cells.map(&:value).compact
        workbook[sheet_name].map do |row|
          new(Hash[header_row.zip(row.cells[0..3])])
        end
      end
    end
  end
end
