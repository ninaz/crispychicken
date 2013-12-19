class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  private

  def require_signin
    unless current_user.present?
      redirect_to root_url, flash[:error] => "Please, log in!"
    end
  end
  
end
