require 'csv'

class UploadedFile < ApplicationRecord
  validates :upload_type,
            presence: true,
            inclusion: %w(cita_appointments)
  validates :filename,
            format: /\A.*\.csv\z/
  validates :data,
            presence: true

  validate :correct_headers

  scope :pending, -> { where(processed: false).order('created_at DESC') }

  def correct_headers
    return unless data.present?

    headers = CSV.new(StringIO.new(data)).first
    missing_headers = REQUIRED_HEADERS - headers

    errors.add(:data, :headers, missing: missing_headers.to_sentence) unless missing_headers.empty?
  end

  REQUIRED_HEADERS = [
    'Created On',
    'Modified On',
    'Scheduled End',
    'Status Reason',
    'Unique',
    'Actual appointment 2',
    'Client ref'
  ].freeze
end
