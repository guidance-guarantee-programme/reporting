class CostPerTransaction
  class SplitByCallVolume
    def initialize(year_month)
      @start_time = year_month.start_time
      @end_time = year_month.end_time
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
      @volume_by_partner ||= begin
        volume_by_partner = TwilioCall.where(called_at: @start_time..@end_time).group(:delivery_partner).count
        if volume_by_partner.none?
          called_at = TwilioCall.where('called_at > ?', @end_time).minimum(:called_at) ||
                      TwilioCall.where('called_at < ?', @start_time).maximum(:called_at)
          period = called_at.beginning_of_month..called_at.end_of_month
          volume_by_partner = TwilioCall.where(called_at: period).group(:delivery_partner).count
        end
        volume_by_partner
      end
    end

    def total_calls
      @total_volume ||= calls_by_partner.sum(&:last)
    end
  end
end
