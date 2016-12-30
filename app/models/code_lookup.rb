class CodeLookup < ApplicationRecord
  class MissingMappingError < StandardError; end

  validates :from, presence: true, uniqueness: true

  def self.for(value:)
    return '' if value.blank?
    find_or_create_by!(from: value).to
  end

  def to
    super || raise(MissingMappingError, from)
  end
end
