require 'rails_helper'
require 'importers'

RSpec.feature 'Importing google `where did you hear about us` data' do
  let(:csv) do
    StringIO.new(
      <<~CSV
        1/27/2016 13:26:15,Pension Provider,L&G,Lochaber Citizens Advice Bureau
      CSV
    )
  end
  let(:entry) { WhereDidYouHear.last }

  scenario 'imports correctly structured data' do
    Importers::WhereDidYouHearAboutUs::Google::Importer.new(
      csv: csv,
      delivery_partner: 'CAS',
      output: StringIO.new
    ).call

    expect(entry.given_at).to eq('2016-01-27 13:26:15 UTC')

    expect(entry).to have_attributes(
      where: 'Pension Provider',
      pension_provider: 'L&G',
      location: 'Lochaber Citizens Advice Bureau',
      delivery_partner: 'CAS'
    )
  end
end
