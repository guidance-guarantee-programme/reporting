class CostPerTransaction
  class SplitByCallVolume
    def initialize(month)
      @start_time = Time.zone.parse("01-#{month}").beginning_of_month
      @end_time = Time.zone.parse("01-#{month}").end_of_month
    end

    def call(cost)
      cost = BigDecimal(cost)

      result = calls_by_partner.each_with_object({}) do |(partner, volume), hash|
        hash[partner] = (cost * volume / total_calls).round(2)
      end

      rounding = cost - result.sum(&:last)

      result[result.keys.last] += rounding

      result
    end

    private

    def calls_by_partner
      @volume_by_partner ||= TwilioCall.where(called_at: @start_time..@end_time).group(:delivery_partner).count
    end

    def total_calls
      @total_volume ||= calls_by_partner.sum(&:last)
    end
  end
end
