class CitaAppointmentsUploadPage < SitePrism::Page
  set_url '/cita_appointment_uploads/new'

  element :attachment, '.t-file-attachment'
  element :upload_button, '.t-upload-button'
  elements :scheduled, '.t-scheduled-file'
  elements :errors, '.t-error'

  def upload(filename)
    attachment.set(filename)
    upload_button.click
  end
end
