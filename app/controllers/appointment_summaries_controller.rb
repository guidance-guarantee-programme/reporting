class AppointmentSummariesController < ApplicationController
  before_action :require_edit_permission!, except: [:index, :show]

  def index
    @appointment_summaries = AppointmentSummaries.new(params[:appointment_summaries])
  end

  def show
    @appointment_summaries = AppointmentSummaries.new(reporting_month: params[:id])
  end

  def new
    @appointment_summary = AppointmentSummary.new(params.permit(:delivery_partner))
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
      :reporting_month,
      :transactions,
      :bookings,
      :completions
    ).merge(source: 'manual')
  end

  def require_edit_permission!
    authorise_user!('analyst')
  rescue PermissionDeniedException
    flash[:warning] = 'You do not have the required permissions'
    redirect_to appointment_summaries_path
  end

  def filtered_appointment_summaries(appointment_summary)
    appointment_summaries_path(appointment_summaries: { delivery_partner: appointment_summary.delivery_partner })
  end
end
