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
          where_did_you_hear!
        end
      rescue CodeLookup::MissingMappingError => e
        Bugsnag.notify(e)
        false
      end

      private

      def calls_by_date!
        calls_by_date = @calls.group_by(&:date)

        calls_by_date.each do |date, calls_for_date|
          daily_call = DailyCallVolume.find_or_initialize_by(date: date)
          daily_call.tp = calls_for_date.count
          daily_call.save!
        end
      end

      def where_did_you_hear!
        @calls.each do |call|
          next unless @filters.all? { |filter| filter.satisfied?(call) }

          WhereDidYouHear
            .find_or_initialize_by(uid: call.uid)
            .update_attributes!(call.params)
        end
      end

      class AfterInfinityCutOver
        CUT_OVER_DATE = Date.new(2016, 2, 5)

        def satisfied?(call)
          call.given_at >= CUT_OVER_DATE
        end
      end

      class IncludedCallOutcome
        INVALID_OUTCOMES = [
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
          'APPOINTMENT ENQUIRY – NO ACTION TAKEN'
        ].freeze

        def satisfied?(call)
          INVALID_OUTCOMES.exclude?(call.outcome.upcase)
        end
      end
    end
  end
end
