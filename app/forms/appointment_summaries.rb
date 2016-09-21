class AppointmentSummaries
  include ActiveModel::Model

  ALL = 'all'.freeze

  attr_reader :delivery_partner, :reporting_month

  def initialize(params)
    params ||= {}
    @delivery_partner = params.fetch(:delivery_partner, ALL)
    @reporting_month = params[:reporting_month]
  end

  def results
    if reporting_month
      AppointmentSummary.where(reporting_month: reporting_month)
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

  private

  def merged_results
    AppointmentSummary
      .where(delivery_partner: Partners.delivery_partners)
      .group(:reporting_month)
      .select(
        :reporting_month,
        'sum(transactions) as transactions',
        'sum(bookings) as bookings',
        'sum(completions) as completions'
      )
  end
end
