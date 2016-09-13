require 'rails_helper'
require Rails.root.join('features/pages/cost_report_page')

RSpec.feature 'Cost Reporting' do
  scenario 'Overall cost per transaction' do
    given_the_following_costs_exist_for_the_month(
      { name: 'Staff', amount: 1000 },
      name: 'Overheads', amount: 2000
    )
    and_transactions_have_been_imported_for_the_month
    when_i_visit_the_costs_report
    then_i_should_see(overall_cost_per_transaction: '£300.00')
  end

  scenario 'Web cost per transaction' do
    given_the_following_costs_exist_for_the_month(
      { name: 'Staff', amount: 1000, web_cost: true },
      name: 'Overheads', amount: 2000, web_cost: false
    )
    and_transactions_have_been_imported_for_the_month
    when_i_visit_the_costs_report
    then_i_should_see_total_costs(web_cost_per_transaction: '£1,000.00')
  end

  scenario 'Partner cost per transaction' do
    given_the_following_costs_exist_for_the_month(
      { name: 'TPAS', amount: 1000, delivery_partner: Partners::TPAS },
      { name: 'CITA', amount: 1000, delivery_partner: Partners::CITA },
      { name: 'CAS', amount: 1000, delivery_partner: Partners::CAS },
      name: 'NICAB', amount: 1000, delivery_partner: Partners::NICAB
    )
    and_transactions_have_been_imported_for_the_month
    when_i_visit_the_costs_report
    then_i_should_see(
      tpas_cost_per_transaction: '£250.00',
      cita_cost_per_transaction: '£333.33',
      cas_cost_per_transaction: '£500.00',
      nicab_cost_per_transaction: '£1,000.00'
    )
  end

  def given_the_following_costs_exist_for_the_month(*costs)
    costs.each do |params|
      cost_item = CostItem.find_by(name: params[:name]) || create(:cost_item, params.except(:amount))
      create(:cost, value_delta: params[:amount], cost_item: cost_item)
    end
  end

  def and_transactions_have_been_imported_for_the_month
    create(:appointment_summary, transactions: 4)
    create(:appointment_summary, transactions: 3, delivery_partner: Partners::CITA)
    create(:appointment_summary, transactions: 2, delivery_partner: Partners::CAS)
    create(:appointment_summary, transactions: 1, delivery_partner: Partners::NICAB)
  end

  def and_call_volumes_exist
    create_list(:twilio_call, 8, delivery_partner: Partners::CITA)
    create_list(:twilio_call, 2, delivery_partner: Partners::CAS)
    create_list(:twilio_call, 2, delivery_partner: Partners::NICAB)
  end

  def when_i_visit_the_costs_report
    @page = CostReportPage.new
    @page.load
  end

  def then_i_should_see(costs)
    costs.each do |field, value|
      expect(@page.current_month.public_send(field).text).to eq(value)
    end
  end

  def then_i_should_see_total_costs(costs)
    costs.each do |field, value|
      expect(@page.current_month.public_send(field).total_cost.text).to eq(value)
    end
  end
end
