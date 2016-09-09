class CostItemsController < ApplicationController
  before_action :require_edit_permission!, except: :index

  def index
    @highlight = CostItem.find_by(id: params[:highlight_id])
    @cost_items = CostItem.current
                          .order(:cost_group, :name)
                          .group_by(&:cost_group)
  end

  def new
    @cost_item = CostItem.new
  end

  def create
    @cost_item = CostItem.new(cost_item_params)

    if @cost_item.save
      redirect_to cost_items_path(anchor: "cost-item-#{@cost_item.id}")
    else
      render :new
    end
  end

  def edit
    @cost_item = CostItem.find(params[:id])
  end

  def update
    @cost_item = CostItem.find(params[:id])

    if @cost_item.update(cost_item_params)
      redirect_to cost_items_path(anchor: "cost-item-#{@cost_item.id}")
    else
      render :edit
    end
  end

  def destroy
    @cost_item = CostItem.find(params[:id])
    @cost_item.update(current: false)

    redirect_to cost_items_path
  end

  private

  def cost_item_params
    params.require(:cost_item).permit(
      :name,
      :cost_group,
      :web_cost,
      :delivery_partner
    )
  end
end
