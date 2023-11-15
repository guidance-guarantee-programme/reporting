require 'csv'
require 'digest'

module Importers
  module CitaSatisfaction
    class Record
      VALID_SMS_VALUES = ('1'..'3').freeze
      VALID_SATISFACTION_VALUES = ('1'..'5').freeze
      SATISFACTION_MAP = {
        '1' => 4,
        '2' => 3,
        '3' => 2,
        '4' => 1,
        '5' => 0
      }.freeze

      attr_reader :delivery_partner

      def initialize(cells, delivery_partner)
        @cells = cells
        @delivery_partner = delivery_partner
      end

      def params
        {
          uid: uid,
          given_at: given_at,
          satisfaction_raw: satisfaction_raw,
          satisfaction: satisfaction,
          sms_response: sms_response,
          location: delivery_partner,
          delivery_partner: Partners::CITA_TELEPHONE
        }
      end

      def uid
        md5 = Digest::MD5.new
        md5 << @cells.join
        md5.hexdigest
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

      def self.build(email)
        delivery_partner = parse_subject(email.subject)

        CSV.parse(email.file.read).tap(&:shift).map { |row| new(row, delivery_partner) }
      end

      def self.parse_subject(subject)
        if matches = subject.match(/\A(.*) Telephony Exit Poll.*\Z/i) # rubocop:disable Style/GuardClause
          matches[1].underscore.tr(' ', '_')
        else
          raise "Could not parse subject: #{subject}"
        end
      end
    end
  end
end
