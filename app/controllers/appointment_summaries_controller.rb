class AppointmentSummariesController < ApplicationController
  before_action :require_edit_permission!, except: %i[index show]

  def index
    @appointment_summaries = AppointmentSummaries.new(params[:appointment_summaries])
  end

  def show
    year_month = YearMonth.find_by!(value: params[:id])
    @appointment_summaries = AppointmentSummaries.new(year_month_id: year_month.id)
  end

  def new
    @appointment_summary = AppointmentSummary.new(
      delivery_partner: params[:delivery_partner],
      year_month_id: YearMonth.current.id
    )
  end

  def create
    @appointment_summary = AppointmentSummary.new(appointment_summary_params)

    if @appointment_summary.save
      redirect_to filtered_appointment_summaries(@appointment_summary)
    else
      render :new
    end
  end

  def edit
    @appointment_summary = AppointmentSummary.find(params[:id])
  end

  def update
    @appointment_summary = AppointmentSummary.find(params[:id])

    if @appointment_summary.update(appointment_summary_params)
      redirect_to filtered_appointment_summaries(@appointment_summary)
    else
      render :edit
    end
  end

  def destroy
    appointment_summary = AppointmentSummary.find(params[:id])
    flash[:notice] =
      if appointment_summary.manual?
        appointment_summary.delete
        "Deleted appointment summary for #{appointment_summary.descripton}"
      else
        "Unable to delete automatically generated appointment summary for #{appointment_summary.descripton}"
      end

    redirect_to filtered_appointment_summaries(appointment_summary)
  end

  private

  def appointment_summary_params
    params.require(:appointment_summary).permit(
      :delivery_partner,
      :year_month_id,
      :transactions,
      :bookings,
      :completions
    ).merge(source: 'manual')
  end

  def filtered_appointment_summaries(appointment_summary)
    appointment_summaries_path(appointment_summaries: { delivery_partner: appointment_summary.delivery_partner })
  end
end
