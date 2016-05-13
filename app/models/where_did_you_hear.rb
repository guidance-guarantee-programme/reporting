class WhereDidYouHear < ActiveRecord::Base
  before_validation :lookup_mappings

  def lookup_mappings
    %w(heard_from pension_provider).each do |field|
      self[field] = CodeLookup.for(value: self["#{field}_code"]) unless self[field].present?
    end
  end
end
