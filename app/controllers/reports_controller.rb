class ReportsController < ApplicationController
  def call_volumes
    @call_volumes = CallVolumes.new(**date_params(:call_volumes))

    respond_to do |format|
      format.html
      format.csv do
        render csv: DailyCallVolumeCsv.new(@call_volumes.results), filename: 'daily_call_volume.csv'
      end
    end
  end

  def costs
    @costs = costs_report
  end

  def cost_breakdowns
    render csv: CostBreakdownCsv.build(costs_report), filename: 'cost_breakdown.csv'
  end

  def cost_breakdowns_raw
    render csv: CostBreakdownRawCsv.new(costs_report.raw), filename: 'cost_breakdown_raw.csv'
  end

  def tp_calls
    @call_volumes = CallVolumes.new(**date_params(:call_volumes))

    respond_to do |format|
      format.csv do
        render csv: TpCallsCsv.new(@call_volumes.tp_calls), filename: 'tp_calls.csv'
      end
    end
  end

  def twilio_calls
    @call_volumes = CallVolumes.new(**date_params(:call_volumes))

    respond_to do |format|
      format.csv do
        render csv: TwilioCallsCsv.new(@call_volumes.twilio_calls), filename: 'twilio_calls.csv'
      end
    end
  end

  def satisfaction_summary
    @satisfactions = Satisfactions.new(**satisfaction_params)
    @satisfaction_summary = SatisfactionSummary.new(@satisfactions.results, @satisfactions.year_month)

    respond_to do |format|
      format.html
      format.csv do
        render csv: SatisfactionSummaryCsv.new(@satisfaction_summary.rows), filename: 'satisfaction_data.csv'
      end
    end
  end

  def satisfaction
    @satisfactions = Satisfactions.new(**satisfaction_params)

    respond_to do |format|
      format.csv { render csv: SatisfactionCsv.new(@satisfactions.results), filename: 'satisfaction_data_raw.csv' }
    end
  end

  def where_did_you_hear
    @where_did_you_hears = WhereDidYouHears.new(**where_did_you_hear_params)

    respond_to do |format|
      format.html
      format.csv do
        render csv: WhereDidYouHearCsv.new(@where_did_you_hears.results), filename: 'where_did_you_hear.csv'
      end
    end
  end

  def where_did_you_hear_summary
    @where_did_you_hears = WhereDidYouHears.new(**where_did_you_hear_params)
    @report = WhereDidYouHearSummary.new(@where_did_you_hears.results)
  end

  def twilio_number_new
    @twilio_numbers_report = TwilioNumbersReport.new

    render 'twilio_numbers'
  end

  def twilio_number_create
    @twilio_numbers_report = TwilioNumbersReport.new(twilio_numbers_report_params)

    if @twilio_numbers_report.valid?
      GenerateTwilioNumbersReport.perform_later(@twilio_numbers_report.emails)
      flash[:success] = "Successfully requested Twilio numbers report for: #{@twilio_numbers_report.email}"
      redirect_to reports_twilio_numbers_new_path
    else
      render 'twilio_numbers'
    end
  end

  private

  def costs_report
    CostsReport.new(
      start_month_id: params.dig(:costs_report, :start_month_id),
      end_month_id: params.dig(:costs_report, :end_month_id)
    )
  end

  def where_did_you_hear_params
    date_params(:where_did_you_hears).merge(page: params[:page])
  end

  def satisfaction_params
    { year_month_id: params.dig(:satisfactions, :year_month_id) }
  end

  def date_params(namespace)
    {
      start_date: params.dig(namespace, :start_date),
      end_date: params.dig(namespace, :end_date)
    }
  end

  def twilio_numbers_report_params
    params.require(:twilio_numbers_report).permit(:email)
  end
end
