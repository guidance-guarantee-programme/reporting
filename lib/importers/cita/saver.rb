module Importers
  module Cita
    class Saver
      def self.save!(record:)
        appointment = Appointment.find_or_initialize_by(uid: record.uid, delivery_partner: Partners::CITA)
        appointment.update!(record.params)
      end
    end
  end
end
