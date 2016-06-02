class SatisfactionSummary
  class Formatter
    def self.percent(value)
      return '' if value.blank?

      value = 100.0 * value

      "#{value.round(1)}%"
    end

    def self.text(value)
      value
    end
  end
end
