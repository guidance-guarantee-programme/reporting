class SatisfactionSummary
  class Row
    def initialize(columns:, field:, format: :text, formatter: Formatter)
      @columns = columns
      @field = field
      @format = format
      @formatter = formatter
    end

    def name
      @field.to_s.tr('_', ' ').capitalize
    end

    def method_missing(method)
      return super unless respond_to?(method)

      format(value(@columns[method]))
    end

    def respond_to_missing?(method, include_private = false)
      @columns.key?(method) || super
    end

    def attributes # rubocop:disable MethodLength
      {
        'name' => name,
        'cas' => cas,
        'cas_telephone' => cas_telephone,
        'cita' => cita,
        'cita_telephone' => cita_telephone,
        'tpas' => tpas,
        'tp' => tp,
        'nicab' => nicab,
        'nicab_telephone' => nicab_telephone,
        'total' => total,
        'weighted_average' => weighted_average
      }
    end

    private

    def value(column)
      return unless column.respond_to?(@field)

      column.public_send(@field)
    end

    def format(value)
      @formatter.public_send(@format, value)
    end
  end
end
