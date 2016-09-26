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
            year_month_id: year_month.id,
            transactions: transactions,
            bookings: 0,
            completions: 0
          }
        end

        def unique_identifier
          params.slice(:year_month_id, :delivery_partner)
        end

        def year_month
          YearMonth.find_or_build(year: @cells[1], month: @cells[0])
        end

        def transactions
          @cells[2].to_i
        end
      end
    end
  end
end
