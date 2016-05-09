require 'rails_helper'
require 'mail_retriever'

RSpec.describe MailRetriever do
  let(:config) { { user_name: 'reporting@pensionwise.gov.uk', password: 'password' } }

  let(:keys) { ['SUBJECT', 'TP Daily Call Data', 'FROM', '@pensionwise.gov.uk'] }
  let(:file_name_regexp) { /File.*\.xlsx/ }

  subject { described_class.new(config: config) }

  it 'initializes the IMAP object' do
    expect(Mail::IMAP).to receive(:new).with(
      address: 'imap.googlemail.com',
      port: 993,
      enable_ssl: true,
      password: 'password',
      user_name: 'reporting@pensionwise.gov.uk'
    )
    subject
  end

  describe '#most_recent' do
    let(:mail) { double(subject: 'Mail 1', attachments: [double(filename: 'File-1.xlsx', decoded: '000')]) }
    let(:uid) { '123456' }

    before do
      allow(Mail).to receive(:last).and_yield(mail, double, uid)
    end

    it 'uses the correct search params' do
      expect(Mail).to receive(:last).with(keys: keys, count: 1, order: :desc)
      subject.most_recent(search_keys: keys, file_name_regexp: file_name_regexp)
    end

    it 'will return the most recent email/attachment matching the search keys' do
      result = subject.most_recent(search_keys: keys, file_name_regexp: file_name_regexp)

      expect(result).to be_a(described_class::EmailAttachment)
      expect(result.uid).to eq(uid)
      expect(result.subject).to eq('Mail 1')
      expect(result.filename).to eq('File-1.xlsx')
    end
  end

  describe '#search' do
    let(:valid_mail_1) { double(subject: 'Mail 1', attachments: [double(filename: 'File-1.xlsx', decoded: '000')]) }
    let(:invalid_mail_1) { double(subject: 'Mail 2', attachments: [double(filename: 'Data-1.xlsx', decoded: '000')]) }
    let(:valid_mail_2) { double(subject: 'Mail 3', attachments: [double(filename: 'File-2.xlsx', decoded: '000')]) }

    before do
      allow(Mail).to receive(:last)
        .and_yield(valid_mail_1, double, '11111')
        .and_yield(invalid_mail_1, double, '22222')
        .and_yield(valid_mail_2, double, '33333')
    end

    it 'uses the correct search params' do
      expect(Mail).to receive(:last).with(keys: keys, count: :all, order: :desc)
      subject.search(search_keys: keys, file_name_regexp: file_name_regexp)
    end

    it 'will return all email/attachment matching the search keys' do
      result = subject.search(search_keys: keys, file_name_regexp: file_name_regexp)

      expect(result.count).to eq(2)
      expect(result.map(&:subject)).to eq(['Mail 1', 'Mail 3'])
    end
  end

  describe '#archive' do
    let(:imap) { double(uid_move: true) }
    let(:uid) { '11111' }

    before do
      allow(Mail).to receive(:last).and_yield(double, imap, double)
    end

    it 'gets the mail by the uid' do
      expect(Mail).to receive(:last).with(uid: uid)
      subject.archive(uid: uid)
    end

    it 'archive the mail based on the uid to the default folder' do
      expect(imap).to receive(:uid_move).with(uid, 'processed')
      subject.archive(uid: uid)
    end

    it 'can be archive to a custom folder' do
      expect(imap).to receive(:uid_move).with(uid, 'error')
      subject.archive(uid: uid, folder: 'error')
    end
  end
end
