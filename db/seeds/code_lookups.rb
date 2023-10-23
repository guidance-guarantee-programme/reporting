if ENV.key?('RESET_CODE_LOOKUPS').blank?
  puts '#####################'
  puts 'Skipping `CodeLookup.delete_all`'
  puts 'If you want to reload all mappings, please run `RESET_CODE_LOOKUPS=true bundle exec rake db:seed`'
else
  CodeLookup.delete_all
end

# where_did_you_hear.where
[
  { from: 'WDYH_PP', to: 'Pension provider' },
  { from: 'WDYH_PW', to: 'On the internet' },
  { from: 'WDYH_CA', to: 'Citizens Advice' },
  { from: 'WDYH_INT', to: 'On the internet' },
  { from: 'WDYH_OTHER', to: 'Other' },
  { from: 'WDYH_ME', to: 'My employer' },
  { from: 'WDYH_NEWS', to: 'Advertising' },
  { from: 'WDYH_WOM', to: 'Friend/Word of mouth' },
  { from: 'WDYH_TV', to: 'Advertising' },
  { from: 'WDYH_RA', to: 'Advertising' },
  { from: 'WDYH_LA', to: 'Advertising' },
  { from: 'WDYH_TPAS', to: 'The Pensions Advisory Service' },
  { from: 'WDYH_FA', to: 'Financial adviser' },
  { from: 'WDYH_SM', to: 'Advertising' },
  { from: 'WDYH_MAS', to: 'Money Advice Service' },
  { from: 'WDYH_JC', to: 'Jobcenter' },
  { from: 'WDYH_CHA', to: 'Charity' },

  { from: 'A Pension Provider', to: 'A Pension Provider' },
  { from: 'Internet search', to: 'Internet search' },
  { from: 'The Government’s Gov.uk website', to: 'The Government’s Gov.uk website' },
  { from: 'The Government’s GOV.UK website', to: 'The Government’s Gov.uk website' },
  { from: 'Radio advert', to: 'Radio advert' },
  { from: 'TV advert', to: 'TV advert' },
  { from: 'Other', to: 'Other' },
  { from: 'An employer', to: 'An employer' },
  { from: 'Citizens Advice', to: 'Citizens Advice' },
  { from: 'Online advertising', to: 'Online advertising' },
  { from: 'TV/radio/newspaper/magazine/online article', to: 'TV/radio/newspaper/magazine/online article' },
  { from: 'Money Advice Service (MAS)', to: 'Money Advice Service (MAS)' },
  { from: 'Relative/Friend/Colleague', to: 'Relative/Friend/Colleague' },
  { from: 'The Pensions Advisory Service (TPAS)', to: 'The Pensions Advisory Service (TPAS)' },
  { from: 'Newspaper/Magazine advert', to: 'Newspaper/Magazine advert' },
  { from: 'Local advertising – billboards, buses, bus stops', to: 'Local advertising – billboards, buses, bus stops' },
  { from: 'Social media', to: 'Social media' },
  { from: 'A Financial Adviser', to: 'A Financial Adviser' },
  { from: 'Jobcentre Plus', to: 'Jobcentre Plus' }
].each do |attrs|
  code_lookup = CodeLookup.find_or_initialize_by(attrs.slice(:from))
  if code_lookup.new_record? || code_lookup.to != attrs[:to]
    code_lookup.update!(attrs)
    WhereDidYouHear.where(heard_from_code: code_lookup.from).update_all(heard_from: code_lookup.to)
  end
end

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
  { from: 'PP_ZURICH', to: 'Zurich' },
  { from: 'PP_AXA', to: 'AXA' },
  { from: 'PP_CANNLINC', to: 'Cannon Lincoln' },
  { from: 'PP_RoyalLondon', to: 'Royal London' },
  { from: 'PP_Reassure', to: 'Reassure' },
  { from: 'PP_Prudential', to: 'Prudential' }
].each { |attrs| CodeLookup.find_or_create_by!(attrs) }
