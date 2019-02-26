# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MercurySso, type: :controller do
  controller(ActionController::Base) do
    include MercurySso

    def index
      head :ok
    end
  end

  context "when not logged in" do
    it "redirects to the sso server" do
      get :index
      expect(response).to redirect_to subject.sso_login_url(false).to_s
    end

    it "sets the authentication intercept" do
      get :index
      expect(session[:authentication_intercept]).to eq "/anonymous"
    end
  end

  context "when logged in" do
    it "allows the request through" do
      get :index, session: { current_user: "Mercury Analytics/scottb" }
      expect(response).to be_ok
    end

    it "provides a helper to access the current user information" do
      get :index, session: { current_user: "Mercury Analytics/scottb" }
      expect(subject.current_user).to eq "Mercury Analytics/scottb"
    end
  end
end
