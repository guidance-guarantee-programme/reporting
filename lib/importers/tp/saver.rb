module Importers
  module TP
    class Saver
      def initialize(calls:, filters: [AfterInfinityCutOver.new, IncludedCallOutcome.new])
        @calls = calls.select(&:valid?)
        @filters = filters
      end

      def save
        ActiveRecord::Base.transaction do
          calls_by_date!
          tp_calls!
          where_did_you_hear!
        end
      rescue CodeLookup::MissingMappingError => e
        Bugsnag.notify(e)
        false
      end

      private

      def calls_by_date!
        calls_by_date = @calls.select { |call| filtered?(:calls_by_date, call) }.group_by(&:date)

        calls_by_date.each do |date, calls_for_date|
          daily_call = DailyCallVolume.find_or_initialize_by(date: date)
          daily_call.contact_centre = calls_for_date.count
          daily_call.save!
        end
      end

      def tp_calls!
        @calls.each do |call|
          next unless filtered?(:calls_by_date, call)

          tp_call = TpCall.find_or_initialize_by(uid: call.uid)
          tp_call.update_attributes!(call.call_params)
        end
      end

      def where_did_you_hear!
        @calls.each do |call|
          next unless filtered?(:where_did_you_hear, call)

          where_did_you_hear = WhereDidYouHear.find_by(uid: call.old_uid) ||
                               WhereDidYouHear.find_or_initialize_by(uid: call.uid)
          where_did_you_hear.update_attributes!(call.wdyh_params)
        end
      end

      def filtered?(filter_type, call)
        @filters.all? { |filter| filter.satisfied?(filter_type, call) }
      end

      class AfterInfinityCutOver
        CUT_OVER_DATE = Date.new(2016, 2, 5)

        def satisfied?(filter_type, call)
          return true unless filter_type == :where_did_you_hear
          call.given_at >= CUT_OVER_DATE
        end
      end

      class IncludedCallOutcome
        INVALID_WHERE_DID_YOU_HEAR_OUTCOMES = [
          'WARM HANDOVER TO CIT-A',
          'WARM HANDOVER TO CAS',
          'WARM HANDOVER TO CAB-NI',
          'TEST CODE',
          'CALLER HUNG UP',
          'WRONG NUMBER',
          'OPEN QUEUE – NOT ANSWERED',
          'AMENDED APPOINTMENT',
          'CANCELLED APPOINTMENT',
          'CUSTOMER CALLED TO CONFIRM APPOINTMENT',
          'APPOINTMENT ENQUIRY – NO ACTION TAKEN',
          'FAILD ATTEMPT TO WARM TRANSFER TO CAB-NI',
          'FAILD ATTEMPT TO WARM TRANSFER TO CAS',
          'FAILD ATTEMPT TO WARM TRANSFER TO CIT-A',
          'REFER TO CAB-N.IRELAND',
          'REFER TO CAS SCOTLAND',
          'REFER TO CIT-A ENGLAND AND WALES'
        ].freeze

        INVALID_CALL_OUTCOMES = [
          'TEST CODE'
        ].freeze

        def satisfied?(filter_type, call)
          case filter_type
          when :where_did_you_hear
            INVALID_WHERE_DID_YOU_HEAR_OUTCOMES.exclude?(call.outcome.upcase)
          when :calls_by_date
            INVALID_CALL_OUTCOMES.exclude?(call.outcome.upcase)
          end
        end
      end
    end
  end
end
