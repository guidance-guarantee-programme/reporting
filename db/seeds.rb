WHERE     = ['Pension Provider', 'Citizens Advice', 'My Employer', 'TV Advert'].freeze
PENSIONS  = ['Hargreaves Lansdown', 'Aeon', 'Standard General', 'TSB'].freeze
LOCATIONS = %w(Dublin Belfast Reading Essex Slough Somerset Cork).freeze
PARTNER   = %w(CAS TPAS NICAB CITA).freeze

puts 'Deleting existing `WhereDidYouHear` records'
WhereDidYouHear.delete_all

puts 'Creating new `WhereDidYouHear` records'

100.times do
  attributes = {
    given_at: rand(-10.days..10.days).seconds.ago,
    location: LOCATIONS.sample,
    delivery_partner: PARTNER.sample,
    where: WHERE.sample,
    pension_provider: PENSIONS.sample
  }

  attributes.except!(:pension_provider) unless attributes[:where] == 'Pension Provider'

  WhereDidYouHear.create!(attributes)
  print '.'
end

puts
puts 'done!'
