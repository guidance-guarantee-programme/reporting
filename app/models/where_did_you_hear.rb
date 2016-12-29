class WhereDidYouHear < ApplicationRecord
  validates :delivery_partner,
            inclusion: { in: Partners.callable_delivery_partners }

  before_validation :lookup_mappings

  def lookup_mappings
    self.heard_from       = CodeLookup.for(value: heard_from_code)
    self.pension_provider = CodeLookup.for(value: pension_provider_code)
  end

  def heard_from=(*)
    heard_from.presence || super
  end

  def pension_provider=(*)
    pension_provider.presence || super
  end
end
