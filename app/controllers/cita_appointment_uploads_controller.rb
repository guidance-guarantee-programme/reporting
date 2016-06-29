class CitaAppointmentUploadsController < ApplicationController
  before_action :require_edit_permission!

  def new
    @scheduled = UploadedFile.pending
    @upload_file = UploadedFile.new
  end

  def create
    @upload_file = UploadedFile.new(uploaded_file_params)

    if @upload_file.save
      redirect_to new_cita_appointment_upload_path
    else
      @scheduled = UploadedFile.pending
      render :new
    end
  end

  private

  def uploaded_file_params
    {
      upload_type: 'cita_appointments',
      filename: params[:appointments_csv].original_filename,
      data: params[:appointments_csv].read
    }
  end
end
