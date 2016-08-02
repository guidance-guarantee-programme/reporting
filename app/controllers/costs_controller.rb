class CostsController < ApplicationController
  before_action :require_edit_permission!, except: :index
  before_action :build_cost_items

  def index
    @monthly_costs = MonthlyCosts.new(month: @selected_month)
  end

  def create
    saver = Costs::Saver.new(costs_items: @costs_items, user: current_user)

    if saver.save(params[:monthly_costs])
      redirect_to costs_path(monthly_costs: { month: @selected_month })
    else
      @monthly_costs = MonthlyCosts.new(month: @selected_month)
      render :index
    end
  end

  private

  def build_cost_items
    @selected_month = params.dig(:monthly_costs, :month) || Time.zone.today.strftime('%Y-%m')
    @costs_items = Costs::Items.new(months: months_around(@selected_month))
  end

  def months_around(selected_month)
    month = Date.parse(selected_month + '-01')
    [
      month << 3,
      month << 2,
      month << 1,
      month,
      month >> 1
    ].map { |m| m.strftime('%Y-%m') }
  end
end
