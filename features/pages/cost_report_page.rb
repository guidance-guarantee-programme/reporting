class CostReportPage < SitePrism::Page
  set_url '/reports/costs'

  sections :months, '.t-months' do
    element :month, '.t-month-name'
    element :overall_cost_per_transaction, '.t-overall'
    section :web_cost_per_transaction, '.t-web' do
      element :total_cost, '.t-total-cost'
    end
    element :tpas_cost_per_transaction, '.t-tpas'
    element :cita_cost_per_transaction, '.t-cita'
    element :cas_cost_per_transaction, '.t-cas'
    element :nicab_cost_per_transaction, '.t-nicab'
  end

  def current_month
    months.detect do |month|
      month.month.text == Time.zone.today.strftime('%b %Y')
    end
  end
end
