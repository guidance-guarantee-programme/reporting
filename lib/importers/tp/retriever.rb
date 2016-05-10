require 'mail_retriever'

module Importers
  module TP
    class Retriever
      SEARCH_KEYS = 'SUBJECT "TP Daily Call Data"'.freeze
      FILE_NAME_REGEXP = /Daily Data File.*\.xlsx/

      def initialize(config:, mail_retriever: MailRetriever)
        @config = config
        @mail_retriever = mail_retriever
      end

      def process_emails
        retriever = @mail_retriever.new(config: @config)
        emails = retriever.search(search_keys: SEARCH_KEYS, file_name_regexp: FILE_NAME_REGEXP)

        succeeded, failed = emails.partition { |email| yield email }
        failed.each { |email| Rails.logger.warn("TP email failed to process: #{email.subject}") }
        succeeded.each { |email| retriever.archive(uid: email.uid) }
      end
    end
  end
end
