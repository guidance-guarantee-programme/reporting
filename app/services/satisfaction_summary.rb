class SatisfactionSummary
  ROWS = [
    { field: :delighted },
    { field: :very_pleased },
    { field: :satisfied },
    { field: :frustrated },
    { field: :very_frustrated },
    { field: :sum_of_score },
    { field: :respondents },
    { field: :top_two_score, format: :percent },
    { field: :gdx_average_score, format: :percent },
    { field: :appointment_completions }
  ].freeze

  def initialize(scope, month)
    @scope = scope.reorder('')
    @month = month
  end

  def rows
    partners = build_partners(
      satisfaction_count: @scope.group(:delivery_partner, :satisfaction).count,
      completion_count: AppointmentSummary.where(reporting_month: reporting_month)
    )

    columns = partners.merge(
      total: TotalColumn.new(partners.values),
      weighted_average: AverageColumn.new(partners.values)
    )

    ROWS.map { |row_settings| Row.new(row_settings.merge(columns: columns)) }
  end

  private

  def build_partners(satisfaction_count:, completion_count:)
    partners = Partners.delivery_partners.each_with_object({}) { |dp, h| h[dp.to_sym] = PartnerColumn.new }

    satisfaction_count.map do |(delivery_partner, satisfaction_score), count|
      partners[delivery_partner.to_sym].satisfaction_data[satisfaction_score] = count
    end

    completion_count.each do |appointment_summary|
      partners[appointment_summary.delivery_partner.to_sym].appointment_completions = appointment_summary.completions
    end

    partners
  end

  def reporting_month
    @month.split('-').reverse.join('-')
  end
end
