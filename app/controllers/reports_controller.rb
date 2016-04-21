class ReportsController < ApplicationController
  def call_volumes
    month = params[:month]
    @first_of_month = Date.parse("#{month}-1") if month
    @first_of_month ||= Time.zone.today.beginning_of_month
    @daily_calls = DailyCall.for_month(@first_of_month)
  end
end
