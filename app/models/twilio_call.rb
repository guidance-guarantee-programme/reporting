class TwilioCall < ApplicationRecord
  OUTCOMES = [
    FORWARDED = 'forwarded'.freeze,
    ABANDONED = 'abandoned'.freeze,
    FAILED = 'failed'.freeze
  ].freeze

  validates :uid, :inbound_number, :called_at,
            presence: true
  validates :outcome,
            inclusion: OUTCOMES
  validates :delivery_partner, inclusion: { in: Partners.face_to_face, allow_blank: true }

  scope :forwarded, -> { where(outcome: TwilioCall::FORWARDED) }
  scope :for_period, ->(period) { where('date(called_at) BETWEEN ? AND ?', period.first, period.last) }
  scope :group_by_date, -> { group('date(called_at)').select('date(called_at)') }

  def self.count_by_partner
    group(:delivery_partner)
      .select(:delivery_partner, 'count(twilio_calls.id) as count')
      .order('')
  end
end
