module Importers
  module BookingBug
    class Saver
      def self.save(record:)
        Appointment
          .find_or_initialize_by(uid: record.uid, delivery_partner: Partners::TPAS)
          .update_attributes!(record.params)
      end
    end
  end
end
