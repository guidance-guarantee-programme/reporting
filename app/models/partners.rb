# frozen_string_literal: true
class Partners
  CAS = 'cas'
  CAS_TELEPHONE = 'cas_telephone'
  CITA = 'cita'
  CITA_TELEPHONE = 'cita_telephone'
  CONTACT_CENTRE = 'contact_centre'
  NICAB = 'nicab'
  NICAB_TELEPHONE = 'nicab_telephone'
  TPAS = 'tpas'
  WEB_VISITS = 'web_visits'
  TP = 'tp'

  def self.delivery_partners
    [CAS, CAS_TELEPHONE, CITA, CITA_TELEPHONE, NICAB, NICAB_TELEPHONE, TPAS, TP]
  end

  def self.callable_delivery_partners
    [CAS, CITA, NICAB, CONTACT_CENTRE]
  end

  def self.face_to_face
    [CAS, CITA, NICAB]
  end
end
