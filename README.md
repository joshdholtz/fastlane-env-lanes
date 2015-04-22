# fastlane-env-lanes
[Fastlane](https://github.com/KrauseFx/fastlane) environment specific lanes (implemented a bit hacky)

## Functionality
- Loads `.env` and `.env.default` with `dotenv`
- Loads `.env.<environment>` for environment passed in through `fastlane test:<environment>`
  - Ex: `fastlane test:production`
- Define lanes for specific environments

## Requirements
- 'fastlane', '~> 0.1.7'
- 'dotenv', '~> 0.7'

## Installation

### Gemfile
```ruby
source 'https://rubygems.org'
ruby "2.0.0"

gem 'fastlane'
gem 'fastlane_env_lanes', '~> 0.2'
```

### Custom Action
A custom action is needed to preload this library properly. Create an action file called `envlanes.rb` in the `fastlane/actions` directory and use the following code below.

```ruby
require 'bundler/setup' # Might need to do this or might not need to do this
require 'fastlane_env_lanes' # <---- THE IMPORTANT STUFF

module Fastlane
  module Actions

    class EnvlanesAction < Action
      def self.run(params)
        Helper.log.info "This should never get run!"
      end
    end
  end
end
```

## Example

```ruby

before_all do |lane|
  # Do some before stuff here
end

lane :test do 
  # snapshot
  puts "test NOT in production"
end

lane :test, :production do
  puts "test in production"
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

## Usage

```sh
--- iOS/YourApp » fastlane test:production
INFO [2015-02-16 15:17:40.68]: Loading from './fastlane/.env.production'
INFO [2015-02-16 15:17:40.68]: Driving the lane 'test__production'
test in production
INFO [2015-02-16 15:17:40.69]: fastlane.tools finished successfully
```

```sh
--- iOS/YourApp » fastlane test        
INFO [2015-02-16 15:19:19.94]: Driving the lane 'test'
test NOT in production
INFO [2015-02-16 15:19:19.94]: fastlane.tools finished successfully 🎉
```
