module Costs
  class Saver
    def initialize(costs_items:, user:)
      @costs_items = costs_items
      @user = user
    end

    def save(params)
      year_month_id = params[:year_month_id]
      Cost.transaction do
        params[:costs].each do |id, cost_params|
          save_cost(id, year_month_id, cost_params[:value], boolean_value(cost_params[:forecast]))
        end
      end
    end

    def save_cost(id, year_month_id, value, forecast)
      cost_value = @costs_items.for(id.to_i, year_month_id.to_i)
      cost_delta = value.to_i - cost_value.value

      if cost_delta != 0
        create_new(id, year_month_id, cost_delta, forecast)
      elsif cost_value.forecast != forecast
        update_forecast(id, year_month_id, forecast)
      end
    end

    def create_new(id, year_month_id, value_delta, forecast)
      Cost.create!(
        cost_item_id: id,
        year_month_id: year_month_id,
        user: @user,
        value_delta: value_delta,
        forecast: forecast
      )
    end

    def update_forecast(id, year_month_id, forecast)
      cost = Cost.order('id desc').find_by(cost_item_id: id, year_month_id: year_month_id)
      cost && cost.update_attributes!(forecast: forecast, user: @user)
    end

    def boolean_value(value)
      {
        '1' => true,
        '0' => false
      }.fetch(value)
    end
  end
end
