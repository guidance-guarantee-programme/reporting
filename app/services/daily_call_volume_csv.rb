# frozen_string_literal: true
class DailyCallVolumeCsv < CsvGenerator
  def attributes
    %w(date twilio tp).freeze
  end
end
