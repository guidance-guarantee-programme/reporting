require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe 'Authenticated engines' do
  shared_examples 'requires authentication' do
    scenario 'requires authentication' do
      with_real_sso do
        they_are_required_to_authenticate
      end
    end

    scenario 'successfully authentication' do
      given_a_user do
        when_they_access_the_engine
        then_they_are_authenticated
      end
    end

    def when_they_access_the_engine
      get path
    end

    def they_are_required_to_authenticate
      expect { get path }.to raise_error(ActionController::RoutingError)
    end

    def then_they_are_authenticated
      expect(response).to be_ok
    end
  end

  context 'Sidekiq control panel' do
    let(:path) { '/sidekiq' }

    include_examples 'requires authentication'
  end

  context 'Blazer reporting interface' do
    let(:path) { '/blazer' }

    include_examples 'requires authentication'
  end
end
# rubocop:enable Metrics/BlockLength
