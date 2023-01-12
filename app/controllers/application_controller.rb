class ApplicationController < ActionController::Base
  include Pagy::Backend

  protect_from_forgery with: :null_session
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  before_action :set_current_user, if: :user_signed_in?

  private

  def set_current_user
    Current.user = current_user
  end
  
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |user| user.permit(:email, :password, :password_confirmation, :first_name, :last_name) }
  end
end
