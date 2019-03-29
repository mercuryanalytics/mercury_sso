# frozen_string_literal: true

module MercurySso
  module SessionsController
    extend MercurySso

    def self.included(base)
      base.skip_before_action :authenticated?
      base.before_action :validate_authentication_ticket, only: :create
    end

    def create
      response.headers.except! "X-Frame-Options"
      render plain: "Login failed"
    end

    def destroy
      self.current_user = nil
      redirect_to sso_logout_url.to_s
    end

    private

    def validate_authentication_ticket
      status, userid = Net::HTTP.get(sso_validate_url(params[:ticket])).split("\n")
      self.current_user = if status == "yes"
                            redirect_to_authentication_intercept
                            self.current_user = userid
                          end
    end

    def redirect_to_authentication_intercept
      auth_intercept = session[:authentication_intercept]
      redirect_to auth_intercept if auth_intercept
    end
  end
end
