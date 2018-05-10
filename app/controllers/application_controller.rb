class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include GDS::SSO::ControllerMethods

  before_action :authenticate_user!

  private

  def require_edit_permission!
    authorise_user!('analyst')
  rescue PermissionDeniedException
    flash[:warning] = 'You do not have the required permissions'
    redirect_to appointment_summaries_path
  end
end
