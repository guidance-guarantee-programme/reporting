class WhereDidYouHear < ActiveRecord::Base
  before_validation :lookup_mappings

  def lookup_mappings
    self.where = CodeLookup.for(value: where_code)
    self.pension_provider = CodeLookup.for(value: pension_provider_code)
  end
end
