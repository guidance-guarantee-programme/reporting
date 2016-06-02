# frozen_string_literal: true
class DeliveryPartner
  CAS = 'cas'
  CITA = 'cita'
  NICAB = 'nicab'
  TP = 'tp'
  TPAS = 'tpas'

  def self.all
    [CAS, CITA, NICAB, TP]
  end

  def self.partners
    [CAS, CITA, NICAB, TPAS]
  end

  def self.face_to_face
    [CAS, CITA, NICAB]
  end
end
