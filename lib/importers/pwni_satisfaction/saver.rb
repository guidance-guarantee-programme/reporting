module Importers
  module PwniSatisfaction
    class Saver
      def initialize(records:)
        @records = records.select(&:valid?)
      end

      def save
        ActiveRecord::Base.transaction do
          satisfaction!
        end
      rescue CodeLookup::MissingMappingError => e
        Bugsnag.notify(e)
        false
      end

      private

      def satisfaction!
        @records.each do |record|
          ::Satisfaction
            .find_or_initialize_by(uid: record.uid)
            .update_attributes!(record.params)
        end
      end
    end
  end
end
