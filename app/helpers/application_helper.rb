module ApplicationHelper
  def friendly_month(month)
    Date.parse("#{month}-1").strftime('%b %Y')
  end
end
