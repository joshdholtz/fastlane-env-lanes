# fastlane-env-lanes
Fastlane environment specific lanes (implemented a bit hacky)

## Requirements
- Currently requires `fastlane` from https://github.com/joshdholtz/fastlane/tree/before-with-lane

## Functionality
- Define lanes for specific environments

```ruby
require 'bundler/setup' # Might need to only do this if installed from git directly
require 'fastlane_env_lanes'

before_all do |lane|
  # Do some before stuff here
end

# Execute by `fastlane beta --env development`
# OR
# Execute by `fastlane beta --env staging`
# OR
# Execute by `fastlane beta`
lane :beta do
  # Do HockeyApp stuff here
end

# Execute by `fastlane beta --env production`
lane :beta, :production do
  # Do Apple TestFlight Beta stuff here
end
```
