require 'mail_retriever'

module Importers
  module CasSatisfaction
    class Retriever
      def initialize(config:, mail_retriever: MailRetriever)
        @config = config
        @mail_retriever = mail_retriever
      end

      def process_emails
        retriever = @mail_retriever.new(config: @config)
        emails = retriever.search(search_keys: @config.search_string, file_name_regexp: @config.file_name_regexp)

        succeeded, failed = emails.partition { |email| yield email }
        failed.each { |email| Rails.logger.warn("CAS satisfaction email failed to process: #{email.subject}") }
        succeeded.each { |email| retriever.archive(uid: email.uid) }
      end
    end
  end
end
