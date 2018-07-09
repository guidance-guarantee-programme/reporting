require 'mail_retriever'

module Importers
  module SmartSurvey
    class Retriever
      def initialize(config:, mail_retriever: MailRetriever)
        @config = config
        @mail_retriever = mail_retriever
      end

      def process_emails
        retriever = @mail_retriever.new(config: @config)
        emails = retriever.search(search_keys: @config.search_string, file_name_regexp: @config.file_name_regexp)

        succeeded, failed = emails.partition do |email|
          delivery_partner = extract_delivery_partner(email)
          delivery_partner && yield(email, delivery_partner)
        end
        failed.each { |email| Rails.logger.warn("Smart survey email failed to process: #{email.subject}") }
        succeeded.each { |email| retriever.archive(uid: email.uid) }
      end

      def extract_delivery_partner(email)
        match = email.body_html.match(@config.delivery_partner_regexp)
        match && match[1]
      end
    end
  end
end
