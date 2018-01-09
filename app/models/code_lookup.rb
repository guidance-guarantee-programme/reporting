class CodeLookup < ApplicationRecord
  class MissingMappingError < StandardError; end

  CORRECTIONS = [
    'online booking',
    'Various',
    'Age UK',
    'Macmillan ',
    'Friend',
    'Leaflet in job centre'
  ].freeze

  validates :from, presence: true, uniqueness: true

  def self.for(value:)
    return '' if value.blank?
    return 'Other' if CORRECTIONS.include?(value)

    find_or_create_by!(from: value).to
  end

  def to
    super || raise(MissingMappingError, from)
  end
end
