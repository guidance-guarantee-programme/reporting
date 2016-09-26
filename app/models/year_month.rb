class YearMonth < ActiveRecord::Base
  class << self
    def get(params)
      year, month = params[:value].split('-')
      find_or_build(year: year, month: month)
    end

    def find_or_build(year:, month:)
      date = Time.zone.parse("#{year}-#{month}-2") # using the 2nd as need a time and what to avoid TZ offset issues
      if year_month = find_by(value: date.strftime('%Y-%m'))
        year_month
      else
        build date
      end
    end

    def build(time)
      create!(
        value: time.strftime('%Y-%m'),
        short_format: time.strftime('%b %Y'),
        start_time: time.beginning_of_month,
        end_time: time.end_of_month
      )
    end

    def current
      today = Time.zone.today
      find_or_build(year: today.year, month: today.month)
    end

    def between(first, last)
      where(start_date: first.start_date..last.start_date).order(:value)
    end
  end

  validates :value, :short_format, presence: true, uniqueness: true

  scope :in_the_past, -> { where(start_date: Time.zone.at(0)..Time.zone.now) }

  has_many :appointment_summaries
  scope :appointment_summaries, -> { joins(:appointment_summaries).group(:id, :short_format).order(value: :desc) }

  def period
    start_time..end_time
  end
end
