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
            delivery_partner: delivery_partner
          }
        end

        def uid
          "#{delivery_partner}:#{@row_index}"
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

        def delivery_partner
          raise NotImplementedError
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
        def delivery_partner
          DeliveryPartner::CAS
        end

        def location
          @cells[10].to_s
        end
      end

      class CitaCallRecord < CallRecord
        def delivery_partner
          DeliveryPartner::CITA
        end

        def location
          @cells[10].to_s
        end
      end

      class NicabCallRecord < CallRecord
        def delivery_partner
          DeliveryPartner::NICAB
        end

        def location
          @cells[7].to_s
        end
      end
    end
  end
end
