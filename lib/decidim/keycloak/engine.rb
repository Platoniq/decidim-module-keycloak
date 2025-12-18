# frozen_string_literal: true

require "omniauth/strategies/keycloak-openid"

module Decidim
  module Keycloak
    # This is the engine that runs on the public interface of keycloak.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Keycloak

      initializer "decidim.keycloak.middleware" do |app|
        omniauth_config = Rails.application.secrets[:omniauth]
        next if omniauth_config[:keycloakopenid].blank?

        app.config.middleware.use OmniAuth::Builder do
          provider :keycloak_openid, setup: lambda { |env|
            request = Rack::Request.new(env)
            callback_uri = Addressable::URI.parse(env["omniauth.strategy"].callback_url).omit(:query)
            organization = Decidim::Organization.find_by(host: request.host)
            config = organization.enabled_omniauth_providers[:keycloakopenid]

            env["omniauth.strategy"].options[:client_id] = config[:client_id]
            env["omniauth.strategy"].options[:client_secret] = config[:client_secret]
            env["omniauth.strategy"].options[:client_options] = { site: config[:site], realm: config[:realm], redirect_uri: callback_uri.to_s }
          }
        end
      end

      config.to_prepare do
        class OmniAuth::Strategies::KeycloakOpenId
          uid { raw_info["preferred_username"] }

          info do
            {
              nickname: raw_info["preferred_username"],
              name: raw_info["name"],
              email: raw_info["email"]
            }
          end
        end
      end

      initializer "decidim_keycloak.webpacker.assets_path" do
        Decidim.register_assets_path File.expand_path("app/packs", root)
      end
    end
  end
end
