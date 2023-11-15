require 'mail'

# USAGE:
#
# manager = MailRetriever.new(
#   config: {
#     user_name: 'reporting@pensionwise.gov.uk',
#     password: <password>
#   }
# )
#
# PASSWORD:
#
# Generate an app specific password following insteructions:
#   https://support.google.com/mail/answer/185833?hl=en&rd=1
#
# manager.all(
#   search_keys: [
#     'SUBJECT', 'TP Daily Call Data',
#     'FROM', '@pensionwise.gov.uk',
#   ],
#   file_name_regexp: /DWP Daily Data File.*\.xlsx/
# )
#

class MailRetriever
  DEFAULT_CONFIG = {
    address: 'outlook.office365.com',
    port: 993,
    enable_ssl: true,
    user_name: nil,
    password: nil
  }.freeze

  def initialize(config:)
    Mail.defaults do
      retriever_method :imap, DEFAULT_CONFIG.merge(config)
    end
  end

  def most_recent(file_name_regexp:, search_keys: 'all')
    search(search_keys: search_keys, file_name_regexp: file_name_regexp, count: 1).first
  end

  def search(file_name_regexp:, count: :all, search_keys: 'all')
    results = []

    Mail.last(count: count, order: :desc, keys: search_keys) do |mail, _imap, uid|
      attachment = mail.attachments.detect { |a| a.filename =~ file_name_regexp }

      results << EmailAttachment.new(uid: uid, attachment: attachment, mail: mail) if attachment
    end

    results
  end

  def archive(uid:, folder: 'processed')
    Mail.last(uid: uid) do |_mail, imap, _uid|
      imap.uid_move(uid, folder)
    end
  end

  class EmailAttachment
    attr_reader :uid, :file, :filename
    delegate :subject, to: :@mail

    def initialize(uid:, attachment:, mail:)
      @uid = uid
      @file = StringIO.new(attachment.decoded)
      @filename = attachment.filename
      @mail = mail
    end

    def body_html
      @mail.html_part.decoded
    end
  end
end
