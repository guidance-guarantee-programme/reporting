class CostsPage < SitePrism::Page
  set_url '/costs'

  sections :cost_items, '.t-cost' do
    element :name, '.t-cost-name'
    element :value, '.t-cost-value'
  end

  element :save_button, '.t-save-button'

  def cost_for(name)
    cost_items.detect { |cost_item| cost_item.name.text == name }.value
  end
end
