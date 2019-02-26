# frozen_string_literal: true

require "mercury_sso/railtie"

module MercurySso
  SSO_SERVER = "researchresultswebsite.com"

  def self.included(base)
    base.class_eval do
      before_action :authenticated?
      helper_method :current_user
    end
  end

  def current_user
    session[:current_user]
  end

  def current_user=(username)
    session[:current_user] = username
  end

  def authenticated?(gateway = false)
    return true if current_user

    session[:authentication_intercept] = request.fullpath
    redirect_to sso_login_url(gateway).to_s
    false
  end

  def sso_login_url(gateway)
    uri = URI::HTTP.build(host: SSO_SERVER, path: "/login")
    options = { service: login_complete_url }
    options[:gateway] = true if gateway
    uri.query = URI.encode_www_form(options)
    uri
  end

  def sso_logout_url
    uri = URI::HTTP.build(host: SSO_SERVER, path: "/logout")
    uri.query = URI.encode_www_form(service: root_url)
    uri
  end

  def sso_validate_url(ticket)
    uri = URI::HTTP.build(host: SSO_SERVER, path: "/validate")
    uri.query = URI.encode_www_form(service: login_complete_url, ticket: ticket)
    uri
  end

  private

  def login_complete_url
    Rails.application.routes.url_helpers.login_complete_url(host: request.host)
  end

  def root_url
    Rails.application.routes.url_helpers.root_url(host: request.host)
  end
end

require "mercury_sso/sessions_controller"
