if ENV.key?('RESET_CODE_LOOKUPS').blank?
  puts '#####################'
  puts 'Skipping `CodeLookup.delete_all`'
  puts 'If you want to reload all mappings, please run `RESET_CODE_LOOKUPS=true bundle exec rake db:seed`'
else
  CodeLookup.delete_all
end

# where_did_you_hear.where
[
  { from: 'WDYH_PP', to: 'Pension Provider' },
  { from: 'WDYH_PW', to: 'Internet' },
  { from: 'WDYH_CA', to: 'Citizen\'s Advice' },
  { from: 'WDYH_INT', to: 'Internet' },
  { from: 'WDYH_OTHER', to: 'Other' },
  { from: 'WDYH_ME', to: 'My Employer' },
  { from: 'WDYH_NEWS', to: 'Advertising' },
  { from: 'WDYH_WOM', to: 'Word of Mouth' },
  { from: 'WDYH_TV', to: 'Advertising' },
  { from: 'WDYH_RA', to: 'Advertising' },
  { from: 'WDYH_LA', to: 'Advertising' },
  { from: 'WDYH_TPAS', to: 'The Pensions Advisory Service' },
  { from: 'WDYH_FA', to: 'Financial Advisor' },
  { from: 'WDYH_SM', to: 'Advertising' },
].each { |attrs| CodeLookup.find_or_create_by!(attrs) }

# where_did_you_hear.pension_provider
[
  { from: 'PP_PHOENIXLIFE', to: 'Phoenix Life' },
  { from: 'PP_SCOTWID', to: 'Scottish Widows' },
  { from: 'PP_OTHER', to: 'Other' },
  { from: 'PP_AVIVA', to: 'Aviva' },
  { from: 'PP_EQLIFE', to: 'Equitable Life' },
  { from: 'PP_L&G', to: 'L&G' },
  { from: 'PP_ABBEYLIFE', to: 'Abbey life' },
  { from: 'PP_STANDLIFE', to: 'Standard Life' },
  { from: 'PP_CANLIFE', to: 'Canada Life' },
  { from: 'PP_SUNLIFE', to: 'Sunlife' },
  { from: 'PP_SUNLIFEOC', to: 'Sunlife Financial of Canada' },
  { from: 'PP_ALLIEDDUN', to: 'Allied Dunbar' },
].each { |attrs| CodeLookup.find_or_create_by!(attrs) }
