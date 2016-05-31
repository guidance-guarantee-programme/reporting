# frozen_string_literal: true
module Importers
  module Google
    module Satisfaction
      class CallRecord
        class NotImplementedError < StandardError; end

        SATISFACTION_VALUE = {
          'Delighted' => 4,
          'Very pleased' => 3,
          'Satisfied' => 2,
          'Frustrated' => 1,
          'Very frustrated' => 0
        }.freeze

        def initialize(cells, row_index)
          @cells = cells
          @row_index = row_index
        end

        def params
          {
            uid: uid,
            given_at: given_at,
            satisfaction_raw: satisfaction_raw,
            satisfaction: satisfaction,
            location: location,
            delivery_partner: self.class::DELIVERY_PARTNER
          }
        end

        def uid
          "#{self.class::DELIVERY_PARTNER}:#{@row_index}"
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
          raise NotImplementedError
        end

        def valid?
          @row_index > 0 && satisfaction_raw.present?
        end

        def self.build(rows, delivery_partner)
          rows.each_with_index.map do |cells, row_index|
            class_for(delivery_partner).new(cells, row_index)
          end
        end

        def self.class_for(delivery_partner)
          case delivery_partner
          when :cas
            CasCallRecord
          when :cita
            CitaCallRecord
          when :nicab
            NicabCallRecord
          end
        end
      end

      class CasCallRecord < CallRecord
        DELIVERY_PARTNER = 'cas'

        def location
          @cells[10].to_s
        end
      end

      class CitaCallRecord < CallRecord
        DELIVERY_PARTNER = 'cita'

        def location
          @cells[10].to_s
        end
      end

      class NicabCallRecord < CallRecord
        DELIVERY_PARTNER = 'nicab'

        def location
          @cells[7].to_s
        end
      end
    end
  end
end
