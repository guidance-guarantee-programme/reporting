module Importers
  module BookingBug
    class Saver
      def self.save(record:)
        appointment = Appointment.find_or_initialize_by(uid: record.uid, delivery_partner: Partners::TPAS)

        if appointment.cancelled?
          appointment.update_attributes!(record.params_without_transaction_at)
        else
          appointment.update_attributes!(record.params)
        end
      end
    end
  end
end
