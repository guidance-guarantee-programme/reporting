class AppointmentSummaries
  include ActiveModel::Model

  ALL = 'all'.freeze

  attr_reader :delivery_partner, :year_month_id

  def initialize(params)
    params ||= {}
    @delivery_partner = params.fetch(:delivery_partner, ALL)
    @year_month_id = params[:year_month_id]
  end

  def results
    if year_month_id
      AppointmentSummary.where(year_month_id: year_month_id)
    elsif merged?
      merged_results
    else
      AppointmentSummary.where(delivery_partner: delivery_partner)
    end
  end

  def filter_options
    [ALL] + Partners.delivery_partners
  end

  def merged?
    delivery_partner == ALL
  end

  def month
    YearMonth.find(@year_month_id).short_format
  end

  private

  def merged_results
    AppointmentSummary.where(delivery_partner: Partners.delivery_partners)
                      .group(:year_month_id)
                      .includes(:year_month)
                      .select(
                        :year_month_id,
                        'sum(transactions) as transactions',
                        'sum(bookings) as bookings',
                        'sum(completions) as completions'
                      )
                      .sort_by { |as| as.year_month.value }
  end
end
