class CostsController < ApplicationController
  before_action :require_edit_permission!, except: :index
  before_action :build_cost_items

  def index
    @monthly_costs = MonthlyCosts.new(year_month_id: @year_month.id)
  end

  def create
    saver = Costs::Saver.new(costs_items: @costs_items, user: current_user)

    if saver.save(params[:monthly_costs])
      redirect_to costs_path(monthly_costs: { year_month_id: @year_month.id })
    else
      @monthly_costs = MonthlyCosts.new(year_month_id: @year_month.id)
      render :index
    end
  end

  private

  def build_cost_items
    @year_month = YearMonth.find_by(id: params.dig(:monthly_costs, :year_month_id)) || YearMonth.current
    @costs_items = Costs::Items.new(year_months: @year_month.around)
  end
end
