# fastlane-env-lanes
[Fastlane](https://github.com/KrauseFx/fastlane) environment specific lanes (implemented a bit hacky)

**Why didn't I make a pull request into Fastlane? -** I [did](https://github.com/KrauseFx/fastlane/pulls?q=is%3Apr+author%3Ajoshdholtz+)! I just got anxious and wanted things now :innocent:

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
gem 'fastlane_env_lanes', :git => 'git@github.com:joshdholtz/fastlane-env-lanes.git'
```

### Fastile
```ruby
require 'bundler/setup' # Might need to only do this if installed from git directly
require 'fastlane_env_lanes'

# Other Fastlane stuff below here
```

## Example

```ruby
require 'bundler/setup' # Might need to only do this if installed from git directly
require 'fastlane_env_lanes'

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
--- iOS/YourApp » fastlane test:staging        
INFO [2015-02-16 15:19:18.94]: Loading from './fastlane/.env.staing'
INFO [2015-02-16 15:19:18.94]: Driving the lane 'test__staging'
INFO [2015-02-16 15:19:18.94]: Driving the lane 'test'
test NOT in production
INFO [2015-02-16 15:19:18.94]: fastlane.tools finished successfully 🎉
```

```sh
--- iOS/YourApp » fastlane test        
INFO [2015-02-16 15:19:19.94]: Driving the lane 'test'
test NOT in production
INFO [2015-02-16 15:19:19.94]: fastlane.tools finished successfully 🎉
```
