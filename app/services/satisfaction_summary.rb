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

  def initialize(scope)
    @scope = scope.reorder('')
  end

  def rows
    partners = build_partners(@scope.group(:delivery_partner, :satisfaction).count)

    columns = partners.merge(
      total: TotalColumn.new(partners.values),
      weighted_average: AverageColumn.new(partners.values)
    )

    ROWS.map { |row_settings| Row.new(row_settings.merge(columns: columns)) }
  end

  private

  def build_partners(count_by_partner_and_score)
    partners = DataSource.delivery_partners.each_with_object({}) { |dp, h| h[dp.to_sym] = PartnerColumn.new }

    count_by_partner_and_score.map do |(delivery_partner, satisfaction_score), count|
      partners[delivery_partner.to_sym].satisfaction_data[satisfaction_score] = count
    end

    partners
  end
end
