class Satisfactions
  include ActiveModel::Model

  attr_accessor :month

  def initialize(month:)
    @month = month || 1.month.ago.strftime('%m-%Y')
    date = Time.zone.parse('1-' + @month)
    @start_time = date.beginning_of_month
    @end_time   = date.end_of_month
  end

  def results
    Satisfaction
      .where(given_at: @start_time..@end_time)
      .order(given_at: :desc)
  end

  def months
    (Satisfaction.minimum(:given_at).to_date..Time.zone.today).map do |date|
      date.strftime('%m-%Y')
    end.uniq.reverse
  end
end
