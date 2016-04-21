class ReportsController < ApplicationController
  def call_volumes
    @call_volumes = CallVolumes.new(
      start_date: params.dig(:call_volumes, :start_date),
      end_date: params.dig(:call_volumes, :end_date)
    )
  end
end
