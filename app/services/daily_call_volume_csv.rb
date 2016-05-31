# frozen_string_literal: true
class DailyCallVolumeCsv < CsvGenerator
  def attributes
    %w(date twilio contact_centre).freeze
  end
end
