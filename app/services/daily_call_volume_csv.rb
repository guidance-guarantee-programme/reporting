class DailyCallVolumeCsv < CsvGenerator
  def attributes
    %w[date contact_centre twilio twilio_cas twilio_cita twilio_nicab twilio_unknown].freeze
  end
end
