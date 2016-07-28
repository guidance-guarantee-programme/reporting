module Costs
  class Saver
    def initialize(costs_items:, user:)
      @costs_items = costs_items
      @user = user
    end

    def save(params)
      month = params[:month]
      Cost.transaction do
        params[:costs].each do |id, cost_params|
          save_cost(id, month, cost_params[:value], boolean_value(cost_params[:forecast]))
        end
      end
    end

    def save_cost(id, month, value, forecast)
      cost_value = @costs_items.for(id.to_i, month)
      cost_delta = value.to_i - cost_value.value

      if cost_delta != 0
        create_new(id, month, cost_delta, forecast)
      elsif cost_value.forecast != forecast
        update_forecast(id, month, forecast)
      end
    end

    def create_new(id, month, value_delta, forecast)
      Cost.create!(
        cost_item_id: id,
        month: month,
        user: @user,
        value_delta: value_delta,
        forecast: forecast
      )
    end

    def update_forecast(id, month, forecast)
      cost = Cost.order('id desc').find_by(cost_item_id: id, month: month)
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
