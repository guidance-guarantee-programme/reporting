require 'rails_helper'
require 'importers'

RSpec.describe Importers::TP::CallRecord do
  subject { described_class.new(rows) }

  let(:rows) { { col1: double(:cell, value: value) } }

  describe 'raw_uid' do
    context 'when value is a numeric' do
      let(:value) { 0.5 }

      it 'converts the value to a string' do
        expect(subject.raw_uid[0]).to eq('0.5')
      end
    end

    context 'when value is a string' do
      let(:value) { '0.5' }

      it 'returns the raw value string' do
        expect(subject.raw_uid[0]).to eq('0.5')
      end
    end

    context 'when value is an incorrect formatted number - with e syntax but no decimal' do
      let(:value) { '500000e-6' }

      it 'correctly formats the number' do
        expect(subject.raw_uid[0]).to eq('0.5')
      end
    end

    context 'when value is a nil' do
      let(:value) { nil }

      it 'returns an empty string' do
        expect(subject.raw_uid[0]).to be_empty
      end
    end
  end
end
