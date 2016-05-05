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

  def where_did_you_hear
    @where_did_you_hears = WhereDidYouHears.new(where_did_you_hear_params)

    respond_to do |format|
      format.html
      format.csv do
        render csv: WhereDidYouHearCsv.new(@where_did_you_hears.results)
      end
    end
  end

  private

  def where_did_you_hear_params
    {
      page: params[:page],
      start_date: params.dig(:where_did_you_hears, :start_date),
      end_date: params.dig(:where_did_you_hears, :end_date)
    }
  end

  def form_params
    {
      start_date: params.dig(:call_volumes, :start_date),
      end_date: params.dig(:call_volumes, :end_date)
    }
  end
end
