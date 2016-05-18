class WhereDidYouHearSummary
  class Row
    attr_reader :count, :total

    def initialize(heard_from:, count:, total:)
      @heard_from = heard_from
      @count = count
      @total = total
    end

    def percentage
      (count.to_f / total.to_f) * 100
    end

    def heard_from
      @heard_from.presence || 'N / A'
    end
  end

  def initialize(records)
    @records = records
  end

  def call
    grouped.map do |heard_from, count|
      Row.new(
        heard_from: heard_from,
        count: count,
        total: total
      )
    end.sort_by(&:count).reverse
  end
  alias rows call

  def total
    @total ||= grouped.values.sum
  end

  private

  def grouped
    @grouped ||= @records.reorder('').group(:heard_from).count
  end
end
