# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def create
    auth = request.env["omniauth.auth"]
    user = User.from_omniauth(auth)

    if authorized_email?(user.email)
      session[:user_id] = user.id
      redirect_to root_path, notice: "Signed in successfully"
    else
      redirect_to root_path, alert: "Unauthorized email address"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "Signed out"
  end

  def failure
    redirect_to root_path, alert: "Authentication failed"
  end

  private

  def authorized_email?(email)
    admin_emails = Rails.application.credentials.dig(:admin_emails)
    admin_emails&.include?(email)
  end
end
