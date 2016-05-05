module Importers
  module DailyCalls
    autoload :Twilio, 'importers/daily_calls/twilio'
    autoload :TP, 'importers/daily_calls/tp'
  end
end
