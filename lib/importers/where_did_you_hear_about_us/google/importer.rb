require 'csv'

module Importers
  module WhereDidYouHearAboutUs
    module Google
      class Importer
        def initialize(csv:, delivery_partner:, output: STDOUT)
          @csv = csv
          @delivery_partner = delivery_partner
          @output = output
        end

        def call
          ActiveRecord::Base.transaction do
            CSV.new(@csv).map { |row| create_from(row) }
          end
        end

        private

        def create_from(row)
          @output.puts "Creating #{row.inspect}"

          WhereDidYouHear.create!(
            given_at: format_date(row[0]),
            where_raw: row[1].to_s,
            pension_provider: row[2].to_s,
            location: row[3].to_s,
            delivery_partner: @delivery_partner
          )
        end

        def format_date(date)
          DateTime.strptime(date, '%m/%d/%Y %H:%M:%S')
        end
      end
    end
  end
end
