Gem::Specification.new do |s|
  s.name        = 'fastlane_env_lanes'
  s.version     = '0.1.2'
  s.date        = '2015-02-17'
  s.summary     = "Fastlane environment specific lanes"
  s.description = "Fastlane environment specific lanes (implemented a bit hacky)"
  s.authors     = ["Josh Holtz"]
  s.email       = 'me@joshholtz.com'
  s.files       = ["lib/fastlane_env_lanes.rb"]
  s.homepage    =
    'https://github.com/joshdholtz/fastlane-env-lanes'
  s.license       = 'MIT'

  s.add_dependency 'fastlane', '~> 0.1.7'
  s.add_dependency 'dotenv', '~> 0.7'
end