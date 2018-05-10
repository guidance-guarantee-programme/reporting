class AddTpRequiredFieldToWhereDidYouHear < ActiveRecord::Migration[4.2]
  def up
    add_column :where_did_you_hears, :uid, :string, default: '', null: false
    add_column :where_did_you_hears, :where_raw, :string, default: '', null: false
    add_column :where_did_you_hears, :where_code, :string, default: '', null: false
    add_column :where_did_you_hears, :pension_provider_code, :string, default: '', null: false

    WhereDidYouHear.reset_column_information

    execute('UPDATE where_did_you_hears SET where_raw = "where"')

    [
      ['Pension Provider', 'WDYH_PP', 'Pension Provider'],
      ['Citizens Advice', 'WDYH_CA', 'Citizen\'s Advice'],
      ['Financial Advisor', 'WDYH_FA', 'Financial Advisor'],
      ['Friend/Word of mouth', 'WDYH_WOM', 'Word of Mouth'],
      ['Google search/Internet', 'WDYH_INT', 'Internet'],
      ['Local advertising', 'WDYH_LA', 'Advertising'],
      ['My employer', 'WDYH_ME', 'My Employer'],
      ['Newspaper/Magazine advert', 'WDYH_NEWS', 'Advertising'],
      ['Other', 'WDYH_OTHER', 'Other'],
      ['pensionwise.gov.uk', 'WDYH_PW', 'Internet'],
      ['Radio advert', 'WDYH_RA', 'Advertising'],
      ['Social media (e.g. Facebook/Twitter)', 'WDYH_SM', 'Advertising'],
      ['The Pensions Advisory Service (TPAS)', 'WDYH_TPAS', 'The Pensions Advisory Service'],
      ['TV advert', 'WDYH_TV', 'Advertising']
    ].each do |raw, code, final|
      WhereDidYouHear.where(where_raw: raw).update_all(where_code: code, where: final)
    end
    WhereDidYouHear.where(where_code: '').update_all(where_code: 'WDYH_OTHER', where: 'Other')
  end

  def down
    execute('UPDATE where_did_you_hears SET "where" = where_raw')

    remove_column :where_did_you_hears, :uid
    remove_column :where_did_you_hears, :where_raw
    remove_column :where_did_you_hears, :where_code
    remove_column :where_did_you_hears, :pension_provider_code
  end
end
