require 'dotenv'

module FastlaneEnvLanes

  class << self; attr_accessor :env_lanes; end

  module FastlaneFastFileExtensions
    def lane(key, env=nil, &block)
      key = (key.to_s + '__' + env.to_s).to_sym if env

      # Stores the lanes that we know
      FastlaneEnvLanes.env_lanes ||= []
      FastlaneEnvLanes.env_lanes << key

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

      # Better checking if the environment lane exists
      if FastlaneEnvLanes.env_lanes && FastlaneEnvLanes.env_lanes.include?(env_key.to_sym)
        super env_key.to_sym
      else
        super lane_key.to_sym
      end

    end
  end
end

module Fastlane
  class FastFile
    prepend FastlaneEnvLanes::FastlaneFastFileExtensions
  end
end

module Fastlane
  class Runner
    prepend FastlaneEnvLanes::FastlaneRunnerExtensions
  end
end