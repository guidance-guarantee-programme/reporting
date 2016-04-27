class ReportsController < ApplicationController
  def call_volumes
    @call_volumes = CallVolumes.new(form_params)

    respond_to do |format|
      format.html
      format.csv do
        filename = "call_volume_#{@call_volumes.period}"
        render csv: DailyCallVolumeCsv.new(@call_volumes.results), filename: filename
      end
    end
  end

  private

  def form_params
    {
      start_date: params.dig(:call_volumes, :start_date),
      end_date: params.dig(:call_volumes, :end_date)
    }
  end
end
