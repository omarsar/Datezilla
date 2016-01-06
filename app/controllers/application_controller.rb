class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
  	devise_parameter_sanitizer.for(:sign_up) << :uuid
	devise_parameter_sanitizer.for(:account_update) << :uuid
	devise_parameter_sanitizer.for(:sign_up) << :username
	devise_parameter_sanitizer.for(:account_update) << :username
	devise_parameter_sanitizer.for(:sign_up) << :biography
	devise_parameter_sanitizer.for(:account_update) << :biography
  	devise_parameter_sanitizer.for(:sign_up) << :birthday
	devise_parameter_sanitizer.for(:account_update) << :birthday
	devise_parameter_sanitizer.for(:sign_up) << :country
	devise_parameter_sanitizer.for(:account_update) << :country
	devise_parameter_sanitizer.for(:sign_up) << :gender
	devise_parameter_sanitizer.for(:account_update) << :gender
	devise_parameter_sanitizer.for(:sign_up) << :status
	devise_parameter_sanitizer.for(:account_update) << :status
	devise_parameter_sanitizer.for(:sign_up) << :gender_preference
	devise_parameter_sanitizer.for(:account_update) << :gender_preference
  end


end
