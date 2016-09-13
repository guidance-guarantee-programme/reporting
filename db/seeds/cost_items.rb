if ENV.key?('RESET_COST_ITEMS').blank?
  puts '#####################'
  puts 'Skipping `CostItem.delete_all` and `Cost.delete_all`'
  puts 'If you want to reload all mappings, please run `RESET_COST_ITEMS=true bundle exec rake db:seed`'
else
  Cost.delete_all
  CostItem.delete_all
end

items = [
  # name                           cost_group   web    delivery_partner
  ['Staffing - web',               'Staff',     true,  ''],
  ['Staffing - non web',           'Staff',     false, ''],
  ['Staffing - web annuities',     'Staff',     true,  ''],
  ['Staffing - non web annuities', 'Staff',     false, ''],

  ['Williams Lea',                 'Contracts', false, 'tpas'],
  ['Royal Mail',                   'Contracts', false, 'tpas'],
  ['Booking Bug',                  'Contracts', false, 'tpas'],

  ['1&1 Internet Limited',         'Contracts', true,  ''],
  ['Amazon Webservices',           'Contracts', true,  ''],
  ['Browser Stack',                'Contracts', true,  ''],
  ['Bugsnag',                      'Contracts', true,  ''],
  ['Cloudflare',                   'Contracts', true,  ''],
  ['Geckoboard',                   'Contracts', true,  ''],
  ['Github',                       'Contracts', true,  ''],
  ['Heroku/New Relic',             'Contracts', true,  ''],
  ['Namecheap.com',                'Contracts', true,  ''],
  ['Pingdom',                      'Contracts', true,  ''],
  ['Memset',                       'Contracts', true,  ''],

  ['Ideal postcodes',              'Contracts', false, 'tpas'],
  ['Twilio',                       'Contracts', false, 'split_by_call_volume'],
  ['Teleperformance',              'Contracts', false,  ''],

  ['TPAS',                         "DP's",      true,  'tpas'],
  ['CITA',                         "DP's",      false, 'cita'],
  ['CAS',                          "DP's",      false, 'cas'],
  ['NICAB',                        "DP's",      false, 'nicab'],

  ['Marketing',                    'Marketing', false, ''],
  ['Overheads - web',              'Overheads', true,  ''],
  ['Overheads - non web',          'Overheads', false, ''],
]


items.each do |name, cost_group, web_cost, delivery_partner|
  CostItem.find_or_create_by!(
    name: name,
    cost_group: cost_group,
    web_cost: web_cost,
    delivery_partner: delivery_partner
  )
end
