require 'rails_helper'

RSpec.describe AuthenticatedUser do
  describe '#matched?' do
    let(:request) { double(:request, env: { 'warden' => warden }) }

    context 'when warden is not set within environment' do
      let(:warden) { nil }

      it 'returns false' do
        expect(subject.matches?(request)).to be_falsey
      end
    end

    context 'when warden is set within environment' do
      context 'and user is not authenticated' do
        let(:warden) { double(:warden, authenticated?: false) }

        it 'returns false' do
          expect(subject.matches?(request)).to be_falsey
        end
      end

      context 'and user is authenticated' do
        let(:warden) { double(:warden, authenticated?: true, user: user) }

        context 'and user is logged out remotely' do
          let(:user) { double(:user, remotely_signed_out?: true) }

          it 'returns false' do
            expect(subject.matches?(request)).to be_falsey
          end
        end

        context 'and user is not logged out remotely' do
          let(:user) { double(:user, remotely_signed_out?: false) }

          it 'returns true' do
            expect(subject.matches?(request)).to be_truthy
          end
        end
      end
    end
  end
end
