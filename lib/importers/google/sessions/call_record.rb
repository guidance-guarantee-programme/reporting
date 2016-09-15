module Importers
  module Google
    module Sessions
      class CallRecord
        def initialize(cells)
          @cells = cells
        end

        def params
          {
            delivery_partner: Partners::WEB_VISITS,
            reporting_month: reporting_month,
            transactions: transactions,
            bookings: 0,
            completions: 0
          }
        end

        def unique_identifier
          params.slice(:reporting_month, :delivery_partner)
        end

        def reporting_month
          "#{year}-#{two_digit_month}"
        end

        def transactions
          @cells[2].to_i
        end

        private

        def year
          @cells[1]
        end

        def two_digit_month
          "0#{@cells[0]}"[-2..-1]
        end
      end
    end
  end
end
