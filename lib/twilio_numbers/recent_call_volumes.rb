module TwilioNumbers
  class RecentCallVolumes
    def process(phone_numbers, period_starts:)
      period_starts.each do |period_start|
        period = period_start.days.ago.beginning_of_day..Time.zone.now
        add_call_count(phone_numbers, period_start, period)
        add_call_cost(phone_numbers, period_start, period)
      end

      add_last_called(phone_numbers)
    end

    private

    def add_call_count(phone_numbers, days_ago, period)
      call_count = TwilioCall.where(called_at: period).group(:inbound_number).count
      call_count.each do |inbound_number, count|
        phone_number = phone_numbers.for(inbound_number)
        phone_number.set(:"calls_in_last_#{days_ago}_days", count)
      end
    end

    def add_call_cost(phone_numbers, days_ago, period)
      call_cost = TwilioCall.where(called_at: period).group(:inbound_number).sum(:cost)
      call_cost.each do |inbound_number, cost|
        phone_number = phone_numbers.for(inbound_number)
        phone_number.set(:"call_costs_in_last_#{days_ago}_days", cost)
      end
    end

    def add_last_called(phone_numbers)
      last_call_time = TwilioCall.group(:inbound_number).maximum(:called_at)
      last_call_time.each do |inbound_number, called_at|
        next unless phone_numbers.exists?(inbound_number)
        phone_numbers.for(inbound_number).set(:last_called_at, called_at)
      end
    end
  end
end
