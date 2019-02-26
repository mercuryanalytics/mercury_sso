# frozen_string_literal: true

require 'rails_helper'
require 'net/http'

RSpec.describe SessionsController, type: :controller do
  controller(ApplicationController) do
    include MercurySso::SessionsController

    def index
      head :ok
    end
  end

  context "#create" do
    before(:example) do
      allow(Net::HTTP).to receive(:get).with(URI).and_return validation_response
    end

    context "with a valid ticket" do
      let(:validation_response) { "yes\nMercury Analytics/scottb" }

      it "redirects to the authentication intercept" do
        get :create, params: { ticket: "ticket" }, session: { authentication_intercept: "/anonymous" }

        expect(response).to redirect_to "/anonymous"
      end

      it "sets the current user" do
        get :create, params: { ticket: "ticket" }, session: { authentication_intercept: "/anonymous" }

        expect(session[:current_user]).to eq "Mercury Analytics/scottb"
      end
    end

    context "with an invalid ticket" do
      let(:validation_response) { "no" }

      it "reports a login failure" do
        get :create, params: { ticket: "ticket" }, session: { authentication_intercept: "/anonymous" }

        expect(response.body).to eq "Login failed"
      end

      it "clears the current user" do
        get :create, params: { ticket: "ticket" }, session: { authentication_intercept: "/anonymous" }

        expect(session[:current_user]).to be_nil
      end
    end
  end

  context "#destroy" do
    before(:example) do
      routes.draw { get "destroy" => "anonymous#destroy" }
    end

    it "clears the session" do
      get :destroy, session: { current_user: "Mercury Analytics/scottb" }

      expect(session[:current_user]).to be_nil
    end

    it "redirects to the sso logout url" do
      get :destroy, session: { current_user: "Mercury Analytics/scottb" }

      expect(response).to redirect_to subject.sso_logout_url.to_s
    end
  end
end
