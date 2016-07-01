module Importers
  module BookingBug
    class Record
      FIELDS = %w(id datetime updated_at created_at is_cancelled service_name).freeze
      DEFAULT_BOOKING_STATUS = 'Awaiting Status'.freeze
      PENSIONWISE_APPOINTMENT = 'Pensionwise Callback'.freeze

      def initialize(data)
        @row = data.slice(*FIELDS)
        @answers = build_questions_and_answers(data.dig('_embedded', 'answers') || [])
      end

      def params_without_transaction_at
        {
          uid: uid,
          booked_at: created_at,
          cancelled: is_cancelled,
          booking_at: datetime,
          booking_status: booking_status,
          delivery_partner: Partners::TPAS,
          created_at: updated_at
        }
      end

      def params
        transaction_at = is_cancelled ? updated_at : datetime

        params_without_transaction_at.merge(transaction_at: transaction_at)
      end

      FIELDS.each do |field|
        define_method(field) do
          @row[field]
        end
      end

      alias uid id

      def booking_status
        @answers.fetch('Booking', DEFAULT_BOOKING_STATUS)
      end

      def build_questions_and_answers(raw_data)
        raw_data.each_with_object({}) do |question_and_answer, hash|
          question = question_and_answer['question_text']
          answer = question_and_answer['value']

          hash[question] = answer if answer.present?
        end
      end

      def valid?
        service_name == PENSIONWISE_APPOINTMENT
      end
    end
  end
end
