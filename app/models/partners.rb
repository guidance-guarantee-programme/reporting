# frozen_string_literal: true
class Partners
  CAS = 'cas'
  CITA = 'cita'
  CONTACT_CENTRE = 'contact_centre'
  NICAB = 'nicab'
  TPAS = 'tpas'
  WEB_VISITS = 'web_visits'

  def self.delivery_partners
    [CAS, CITA, NICAB, TPAS]
  end

  def self.callable_delivery_partners
    [CAS, CITA, NICAB, CONTACT_CENTRE]
  end

  def self.face_to_face
    [CAS, CITA, NICAB]
  end
end
