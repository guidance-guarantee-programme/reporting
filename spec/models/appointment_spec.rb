require 'rails_helper'

RSpec.describe Appointment, type: :model do
  describe 'versioning' do
    subject { create(:appointment) }

    it 'sets the version to 1 when a new record is created' do
      expect(subject.version).to eq(1)
    end

    it 'increments the version when the record is changed' do
      subject.booking_status = 'Awaiting Status'
      subject.save
      expect(subject.version).to eq(2)
    end

    it 'does not increment the version if the records is not changed' do
      subject.save
      expect(subject.version).to eq(1)
    end
  end
end
