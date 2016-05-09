require 'mail_retriever'

module Importers
  module DailyCalls
    module TP
      class Retriever
        class MissingProcessingBlockError < StandardError; end

        SEARCH_KEYS = 'SUBJECT "TP Daily Call Data"'.freeze
        FILE_NAME_REGEXP = /Daily Data File.*\.xlsx/

        def initialize(config:, mail_retriever: MailRetriever)
          @config = config
          @mail_retriever = mail_retriever
        end

        def process_emails(&block)
          raise MissingProcessingBlockError unless block_given?

          retriever = @mail_retriever.new(config: @config)
          emails = retriever.search(search_keys: SEARCH_KEYS, file_name_regexp: FILE_NAME_REGEXP)

          emails.each do |email|
            process_email(retriever, email, &block)
          end
        end

        def process_email(retriever, email)
          yield email
          retriever.archive(uid: email.uid)
        rescue => e
          Bugsnag.notify(e)
        end
      end
    end
  end
end
