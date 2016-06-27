require 'csv'

class PopulateHistoricalAppointmentSummaryData < ActiveRecord::Migration
  DATA = <<~CSV
    Month,CITA Bookings,CAS Bookings,NICAB Bookings,TPAS Bookings,CITA Transactions,CAS Transactions,NICAB Transactions,TPAS Transactions,CITA Completions,CAS Completions,NICAB Completions,TPAS Completions
    Apr-15,1364,319,0,2948,1498,179,0,2340,1423,170,0,1404
    May-15,1794,316,137,1877,1961,299,137,2463,1830,293,137,1598
    Jun-15,1872,276,205,1517,1871,295,205,1792,1846,276,213,1243
    Jul-15,2626,338,185,2052,2665,298,185,2237,2037,264,185,1540
    Aug-15,3557,323,255,1253,2513,298,255,1488,1771,218,255,1065
    Sep-15,3539,412,309,1573,3074,340,288,1570,2208,310,288,1080
    Oct-15,4175,416,341,1412,4642,395,306,1412,3749,378,306,977
    Nov-15,3061,378,307,1090,3521,358,291,1195,3203,332,291,956
    Dec-15,1624,176,123,695,2106,230,124,745,1924,215,124,628
    Jan-16,2718,373,245,1313,2718,287,221,1211,2718,276,221,846
    Feb-16,3924,388,358,1520,3745,392,343,1436,3423,331,343,1142
    Mar-16,4903,453,243,2555,4347,406,188,2061,3869,402,188,1586
    Apr-16,4123,366,191,1707,4321,369,202,2010,3793,336,202,1577
    May-16,2925,275,172,1210,3128,276,150,1301,2771,264,150,1070
  CSV

  def up
    return if Rails.env.test?

    data = CSV.parse(DATA, headers: true)
    data.each do |month_row|
      create_appointment_summary(data: month_row, delivery_partner: 'cas')
      create_appointment_summary(data: month_row, delivery_partner: 'cita')
      create_appointment_summary(data: month_row, delivery_partner: 'nicab')
      create_appointment_summary(data: month_row, delivery_partner: 'tpas')
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

  def create_appointment_summary(data:, delivery_partner:)
    summary = AppointmentSummary.find_or_initialize_by(
      delivery_partner: delivery_partner,
      reporting_month: reporting_month(data['Month'])
    )

    summary.transactions = data["#{delivery_partner.upcase} Transactions"]
    summary.bookings = data["#{delivery_partner.upcase} Bookings"]
    summary.completions = data["#{delivery_partner.upcase} Completions"]
    summary.source = 'manual'

    summary.save!
  end

  def reporting_month(val)
    Date.parse("01-#{val}").strftime('%Y-%m')
  end
end
