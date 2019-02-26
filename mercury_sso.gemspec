$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "mercury_sso/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "mercury_sso"
  spec.version     = MercurySso::VERSION
  spec.authors     = ["Scott Brickner"]
  spec.email       = ["scottb@brickner.net"]
  spec.homepage    = "https://github.com/mercuryanalytics/mercury_sso"
  spec.summary     = "Mercury Analytics single sign-on system integration"
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  raise "RubyGems 2.0 or newer is required to protect against public gem pushes." unless spec.respond_to?(:metadata)

  spec.metadata["allowed_push_host"] = "http://gemserver.mercuryanalytics.com"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 5.2.2"

  spec.add_development_dependency "pg"
  spec.add_development_dependency "rspec-rails"
end
