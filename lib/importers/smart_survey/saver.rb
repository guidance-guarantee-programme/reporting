module Importers
  module SmartSurvey
    class Saver
      def initialize(records:)
        @records = records.select(&:valid?)
      end

      def save
        ActiveRecord::Base.transaction do
          where_did_you_hear!
        end
      rescue CodeLookup::MissingMappingError => e
        Bugsnag.notify(e)
        false
      end

      private

      def where_did_you_hear!
        @records.each do |call|
          WhereDidYouHear
            .find_or_initialize_by(uid: call.uid)
            .update_attributes!(call.params)
        end
      end
    end
  end
end
