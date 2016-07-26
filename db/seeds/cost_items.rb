if ENV.key?('RESET_COST_ITEMS').blank?
  puts '#####################'
  puts 'Skipping `CostItem.delete_all` and `Cost.delete_all`'
  puts 'If you want to reload all mappings, please run `RESET_COST_ITEMS=true bundle exec rake db:seed`'
else
  Cost.delete_all
  CostItem.delete_all
end

items = <<~ITEMS
  Overheads
  Williams Lea
  Royal Mail
  Booking Bug
  Teleperformance
  Marketing
  TPAS
  CitA
  CAS
  NICAB
  PW Core
  2MA
ITEMS

items.split("\n").each do |name|
  CostItem.find_or_create_by!(name: name)
end
