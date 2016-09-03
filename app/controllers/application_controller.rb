class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?


  def configure_permitted_parameters
   devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :avatar, :avatar_cache, :admin, :nom, :prenom, :comment, :adress, :zipcode, :subscribe, :city, :dob, :latitude, :longitude, :gender, :driver, :cbrand_id, :cmodel_id, :carsize, :phone, :xp) }
      devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :avatar, :avatar_cache, :admin, :nom, :prenom, :comment, :adress, :zipcode, :subscribe, :dob, :city, :latitude, :longitude, :gender, :driver, :cbrand_id, :cmodel_id, :carsize, :phone, :xp, :current_password) }
  end
end
