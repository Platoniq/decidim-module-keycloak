# frozen_string_literal: true

require "spec_helper"

describe "Login page" do
  let!(:organization) { create(:organization) }

  before do
    organization.omniauth_settings = omniauth_settings.transform_values do |v|
      Decidim::OmniauthProvider.value_defined?(v) ? Decidim::AttributeEncryptor.encrypt(v) : v
    end
    organization.save

    switch_to_host(organization.host)
    visit decidim.new_user_session_path
  end

  context "when keycloak enabled" do
    let(:omniauth_settings) do
      {
        omniauth_settings_keycloakopenid_enabled: true,
        omniauth_settings_keycloakopenid_icon_path: "media/images/keycloak_logo.svg",
        omniauth_settings_keycloakopenid_client_id: "Example-Client",
        omniauth_settings_keycloakopenid_client_secret: "example-secret-for-keycloak",
        omniauth_settings_keycloakopenid_site: "http://localhost:8080/",
        omniauth_settings_keycloakopenid_realm: "example-realm"
      }
    end

    it "has button" do
      expect(page).to have_content "Sign in with Keycloakopenid"
    end
  end

  context "when keycloak disabled" do
    let(:omniauth_settings) do
      {
        omniauth_settings_keycloakopenid_enabled: false
      }
    end

    it "has no button" do
      expect(page).to have_no_content "Sign in with Keycloakopenid"
    end
  end
end
