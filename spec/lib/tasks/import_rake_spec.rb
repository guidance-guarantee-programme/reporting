require 'rails_helper'
require 'rake'

RSpec.describe 'import' do
  before :all do
    Rake.application.rake_require 'tasks/import'
    Rake::Task.define_task(:environment)
  end

  skip 'import:twilio' do
    let(:run_rake_task) do
      Rake::Task['import:twilio'].reenable
      Rake.application.invoke_task 'import:twilio'
    end

    it 'queues the job for the previous day' do
      expect(ImportTwilioData).to receive(:perform_later).with(Time.zone.yesterday.to_s)
      run_rake_task
    end

    context 'valid DATE param is passed in' do
      before do
        allow(ENV).to receive(:fetch).with('DATE', anything).and_return('2016-01-01')
      end

      it 'will queue the job for the passedin DATE' do
        expect(ImportTwilioData).to receive(:perform_later).with('2016-01-01')
        run_rake_task
      end
    end

    context 'invalid DATE param is passed in' do
      before do
        allow(ENV).to receive(:fetch).with('DATE', anything).and_return('2016-aa-01')
      end

      it 'will not queue a job' do
        expect(ImportTwilioData).not_to receive(:perform_later)
      end

      it 'will raise an exception' do
        expect { run_rake_task }.to raise_error(ArgumentError)
      end

      it 'will notify bugsnag of the exception' do
        expect(Bugsnag).to receive(:notify).with(an_instance_of(ArgumentError))
        expect { run_rake_task }.to raise_error(ArgumentError)
      end
    end
  end
end
