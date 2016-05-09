module Importers
  module DailyCalls
    module TP
      class CallRecord
        MINIMUM_CALL_TIME = 10

        def initialize(row)
          @row = row
        end

        def date
          value = @row[0]&.value
          value.respond_to?(:utc) && value.utc.to_date
        end

        def outcome
          @row[8]&.value
        end

        def valid?
          outcome.present? && date && outcome.to_s !~ /test/i
        end

        def self.build(io)
          workbook = RubyXL::Parser.parse_buffer(io)
          workbook['Call Details'].map do |row|
            new(row.cells.to_a)
          end
        end
      end
    end
  end
end
