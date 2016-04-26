# frozen_string_literal: true
require 'csv'

class DailyCallVolumeCsv
  ATTRIBUTES = %w(
    date
    call_volume
  ).freeze

  def initialize(daily_call_volumes)
    @daily_call_volumes = Array(daily_call_volumes)
  end

  def call
    CSV.generate do |output|
      output << ATTRIBUTES

      daily_call_volumes.each { |daily_call_volume| output << row(daily_call_volume) }
    end
  end
  alias csv call

  private

  attr_reader :daily_call_volumes

  def row(daily_call_volume)
    daily_call_volume
      .attributes
      .slice(*ATTRIBUTES)
      .values
      .map(&:to_s)
  end
end
