# based off https://github.com/lostisland/faraday/blob/master/lib/faraday/response/logger.rb
require 'forwardable'

class ResponseLogger < Faraday::Response::Middleware
  extend Forwardable

  def initialize(app, logger = nil)
    super(app)
    @logger = logger || begin
      require 'logger'
      ::Logger.new($stdout)
    end
  end

  def_delegators :@logger, :debug, :info, :warn, :error, :fatal

  def call(env)
    info('Request') { "#{env.method} #{env.url}" }
    super
  end

  def on_complete(env)
  end
end
