require 'dotenv'

module FastlaneFastFileExtensions
  def lane(key, env=nil, &block)
    key = (key.to_s + '__' + env.to_s).to_sym if env
    super key, &block
  end
end

module FastlaneRunnerExtensions
  def execute(key)

    # env = Fastlane::Actions.lane_context[ Fastlane::Actions::SharedValues::ENVIRONMENT ]
    # env_key = (key.to_s + '__' + env.to_s).to_sym if env
    
    env_key = key.to_s.gsub(':', '__')
    lane_key = env_key.split('__')[0]

    # Making sure the default '.env' and '.env.default' get loaded
    env_file = File.join(Fastlane::FastlaneFolder.path || "", '.env')
    env_default_file = File.join(Fastlane::FastlaneFolder.path || "", '.env.default')
    Dotenv.load(env_file, env_default_file)

    # Loads .env file for the environment passed in through options
    if env_key.split('__').size > 1
      env = env_key.split('__')[1]

      env_file = File.join(Fastlane::FastlaneFolder.path || "", ".env.#{env}")
      Fastlane::Helper.log.info "Loading from '#{env_file}'".green
      Dotenv.overload(env_file)
    end

    begin
      super env_key.to_sym
    rescue
      super lane_key.to_sym
    end
  end
end

module Fastlane
  class FastFile
    prepend FastlaneFastFileExtensions
  end
end

module Fastlane
  class Runner
    prepend FastlaneRunnerExtensions
  end
end