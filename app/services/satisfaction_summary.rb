class SatisfactionSummary
  ROWS = [
    { field: :very_satisfied },
    { field: :fairly_satisfied },
    { field: :neither_satisfied_nor_dissatisfied },
    { field: :fairly_dissatisfied },
    { field: :very_dissatisfied },
    { field: :sum_of_score },
    { field: :respondents },
    { field: :top_two_score, format: :percent },
    { field: :gdx_average_score, format: :percent },
    { field: :appointment_completions }
  ].freeze

  def initialize(scope, year_month)
    @scope = scope.reorder('')
    @year_month = year_month
  end

  def rows
    partners = build_partners(
      satisfaction_count: @scope.group(:delivery_partner, :satisfaction).count,
      completion_count: AppointmentSummary.non_web.where(year_month_id: @year_month.id)
    )

    columns = partners.merge(
      total: TotalColumn.new(partners.values),
      weighted_average: AverageColumn.new(partners.values)
    )

    ROWS.map { |row_settings| Row.new(**row_settings.merge(columns: columns)) }
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
end
