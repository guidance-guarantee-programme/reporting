require 'rails_helper'

RSpec.describe ImportTwilioDataJob, type: :job do
  include ActiveJob::TestHelper

  let(:date) { Time.zone.yesterday }

  subject(:job) { described_class.perform_later(date.to_s) }

  it 'queues the job' do
    expect { job }
      .to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
  end

  it 'performs the job - with correctly parsed date value' do
    expect_any_instance_of(DailyCalls::Twilio::Importer).to receive(:import).with(start_date: date, end_date: date)
    perform_enqueued_jobs { job }
  end

  shared_examples_for 'invalid parameter passed in' do
    it 'raise an error to bugsnag' do
      expect(Bugsnag).to receive(:notify).with(an_instance_of(ImportTwilioDataJob::InvalidDateParameter))

      described_class.perform_now(*args)
    end

    it 'does not manually rescheduled the job' do
      expect_any_instance_of(described_class).not_to receive(:retry_job)
      described_class.perform_now(*args)
    end

    it 'does not automatically reschedule the job - sidekiq' do
      expect { described_class.perform_now(*args) }.not_to raise_error
    end
  end

  context 'date object parameter' do
    let(:args) { [date] }

    it_behaves_like 'invalid parameter passed in'
  end

  context 'invalid date string' do
    let(:args) { ['2014-aa-19'] }

    it_behaves_like 'invalid parameter passed in'
  end

  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end
end