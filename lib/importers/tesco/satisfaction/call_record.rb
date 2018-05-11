module Importers
  module Tesco
    module Satisfaction
      class CallRecord
        SATISFACTION_VALUE = {
          'Very satisfied' => 4,
          'Fairly satisfied' => 3,
          'Neither satisfied nor dissatisfied' => 2,
          'Fairly dissatisfied' => 1,
          'Very dissatisfied' => 0
        }.freeze

        LOCATION_COLUMN         = { 'nicab' => 1, 'cas' => 1, 'cita' => 2 }.freeze
        SATISFACTION_RAW_COLUMN = { 'nicab' => 3, 'cas' => 3, 'cita' => 4 }.freeze
        APPOINTMENT_DATE_COLUMN = { 'nicab' => 2, 'cas' => 2, 'cita' => 3 }.freeze

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
          "tesco:#{@delivery_partner}:#{@row_index}:#{given_at.to_i}"
        end

        def given_at
          date = @cells[APPOINTMENT_DATE_COLUMN[@delivery_partner]]

          Time.zone.parse("#{date} 09:00")
        end

        def satisfaction_raw
          satisfaction_raw_column = SATISFACTION_RAW_COLUMN[@delivery_partner]
          @cells[satisfaction_raw_column].to_s
        end

        def satisfaction
          SATISFACTION_VALUE[satisfaction_raw]
        end

        def location
          location_column = LOCATION_COLUMN[@delivery_partner]
          @cells[location_column].to_s
        end

        def valid?
          @row_index.positive? && satisfaction_raw.present?
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
