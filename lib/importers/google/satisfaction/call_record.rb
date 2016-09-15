module Importers
  module Google
    module Satisfaction
      class CallRecord
        SATISFACTION_VALUE = {
          'Delighted' => 4,
          'Very pleased' => 3,
          'Satisfied' => 2,
          'Frustrated' => 1,
          'Very frustrated' => 0
        }.freeze

        LOCATION_COLUMN = {
          'cas' => 10,
          'cita' => 10,
          'nicab' => 7
        }.freeze

        def initialize(cells, row_index, delivery_partner)
          @cells = cells
          @row_index = row_index
          @delivery_partner = delivery_partner
        end

        def params
          {
            uid: uid,
            given_at: given_at,
            satisfaction_raw: satisfaction_raw,
            satisfaction: satisfaction,
            location: location,
            delivery_partner: @delivery_partner
          }
        end

        def uid
          "#{@delivery_partner}:#{@row_index}"
        end

        def given_at
          Time.zone.parse(@cells[0])
        end

        def satisfaction_raw
          @cells[2].to_s
        end

        def satisfaction
          SATISFACTION_VALUE[satisfaction_raw]
        end

        def location
          location_column = LOCATION_COLUMN[@delivery_partner]
          @cells[location_column].to_s
        end

        def valid?
          @row_index > 0 && satisfaction_raw.present?
        end

        def self.build(rows, delivery_partner)
          rows.each_with_index.map do |cells, row_index|
            new(cells, row_index, delivery_partner.to_s)
          end
        end
      end
    end
  end
end
