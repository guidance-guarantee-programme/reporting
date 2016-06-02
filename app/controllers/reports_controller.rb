class ReportsController < ApplicationController
  def call_volumes
    @call_volumes = CallVolumes.new(date_params(:call_volumes))

    respond_to do |format|
      format.html
      format.csv do
        filename = "call_volume_#{@call_volumes.period}"
        render csv: DailyCallVolumeCsv.new(@call_volumes.results), filename: filename
      end
    end
  end

  def satisfaction_summary
    @satisfactions = Satisfactions.new(satisfaction_params)
    @satisfaction_summary = SatisfactionSummary.new(@satisfactions.results)

    respond_to do |format|
      format.html
      format.csv do
        render csv: SatisfactionSummaryCsv.new(@satisfaction_summary.rows), filename: 'satisfaction_data.csv'
      end
    end
  end

  def satisfaction
    @satisfactions = Satisfactions.new(satisfaction_params)

    respond_to do |format|
      format.csv do
        render csv: SatisfactionCsv.new(@satisfactions.results), filename: 'satisfaction_data_raw.csv'
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

  def where_did_you_hear_summary
    @where_did_you_hears = WhereDidYouHears.new(where_did_you_hear_params)
    @report = WhereDidYouHearSummary.new(@where_did_you_hears.results)
  end

  private

  def where_did_you_hear_params
    date_params(:where_did_you_hears).merge(page: params[:page])
  end

  def satisfaction_params
    date_params(:satisfactions)
  end

  def date_params(namespace)
    {
      start_date: params.dig(namespace, :start_date),
      end_date: params.dig(namespace, :end_date)
    }
  end
end
