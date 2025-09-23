# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "decidim/keycloak/version"

Gem::Specification.new do |s|
  s.version = Decidim::Keycloak::VERSION
  s.authors = ["Francisco Bolívar"]
  s.email = ["francisco.bolivar@nazaries.com"]
  s.license = "AGPL-3.0"
  s.homepage = "https://github.com/decidim/decidim-module-keycloak"
  s.required_ruby_version = ">= 3.3.0"

  s.name = "decidim-keycloak"
  s.summary = "A decidim keycloak module"
  s.description = "OmniAuth strategy for Keycloak."

  s.files = Dir["{app,config,lib}/**/*", "LICENSE-AGPLv3.txt", "Rakefile", "README.md"]

  s.add_dependency "decidim-core", Decidim::Keycloak::COMPAT_DECIDIM_VERSION
  s.add_dependency "omniauth-keycloak", "~> 1.5"

  s.add_development_dependency "decidim-dev", Decidim::Keycloak::COMPAT_DECIDIM_VERSION
  s.metadata["rubygems_mfa_required"] = "true"
end
