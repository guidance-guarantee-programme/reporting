module Importers
  module Google
    module Satisfaction
      class CallRecord
        SATISFACTION_VALUE = {
          'Very satisfied' => 4,
          'Fairly satisfied' => 3,
          'Neither satisfied nor dissatisfied' => 2,
          'Fairly dissatisfied' => 1,
          'Very dissatisfied' => 0
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
          "#{@delivery_partner}:#{@row_index}:#{given_at.to_i}"
        end

        def given_at
          Time.zone.parse("#{@cells[2]} 09:00")
        end

        def satisfaction_raw
          @cells[3].to_s
        end

        def satisfaction
          SATISFACTION_VALUE[satisfaction_raw]
        end

        def location
          @cells[1].to_s
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
