module Importers
  module TP
    class Saver
      def initialize(calls:, after_infinity_cut_over: AfterInfinityCutOver.new)
        @calls = calls.select(&:valid?)
        @after_infinity_cut_over = after_infinity_cut_over
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
          next unless @after_infinity_cut_over.satisfied?(call)

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
    end
  end
end
