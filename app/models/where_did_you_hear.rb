class WhereDidYouHear < ActiveRecord::Base
  before_validation :lookup_mappings

  def lookup_mappings
    self.heard_from       = CodeLookup.for(value: heard_from_code)
    self.pension_provider = CodeLookup.for(value: pension_provider_code)
  end
end
