require 'rails_helper'

RSpec.describe CodeLookup do
  describe '.for' do
    context 'empty string/nil value' do
      it 'will map to an empty string' do
        expect(described_class.for(value: '')).to eq('')
        expect(described_class.for(value: nil)).to eq('')
      end
    end

    context 'string value' do
      let(:value) { 'apples' }

      context 'no mapping exists' do
        it 'creates a mapping to a nil string' do
          expect do
            ignoring_mapping_error { described_class.for(value: 'apples') }
          end.to change { CodeLookup.count }.by(1)
        end

        it 'raises an error' do
          expect do
            described_class.for(value: 'apples')
          end.to raise_error(CodeLookup::MissingMappingError)
        end
      end

      context 'mapping with nil return value exists' do
        before { create(:code_lookup, from: 'apples', to: nil) }

        it 'does not create a mapping' do
          expect do
            ignoring_mapping_error { described_class.for(value: 'apples') }
          end.not_to change { CodeLookup.count }
        end

        it 'raises an error' do
          expect do
            described_class.for(value: 'apples')
          end.to raise_error(CodeLookup::MissingMappingError)
        end
      end

      context 'mapping with an empty string return value exists' do
        before { create(:code_lookup, from: 'apples', to: '') }

        it 'returns the empty string' do
          expect(described_class.for(value: 'apples')).to eq('')
        end
      end

      context 'mapping with a string return value exists' do
        before { create(:code_lookup, from: 'apples', to: 'granny smith') }

        it 'returns the mapped string' do
          expect(described_class.for(value: 'apples')).to eq('granny smith')
        end
      end
    end
  end

  def ignoring_mapping_error
    yield
  rescue CodeLookup::MissingMappingError
    nil
  end
end
