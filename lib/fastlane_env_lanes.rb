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
end

module FastlaneLaneManagerExtensions

  module ClassMethods

    def cruise_lane(platform, key, p_env = nil)

      keys = key.split(' ') 
      keys.each do |single_key|
        args = fl_env_lanes_run_lane(platform, single_key, p_env)
        super(args[0], args[1], args[2])
      end

    end

    def fl_env_lanes_run_lane(platform, key, p_env)

      env_key = key.to_s.gsub(':', '__')
      lane_key = env_key.split('__')[0]

      # Making sure the default '.env' and '.env.default' get loaded
      env_file = File.join(Fastlane::FastlaneFolder.path || "", '.env')
      env_default_file = File.join(Fastlane::FastlaneFolder.path || "", '.env.default')
      Dotenv.load(env_file, env_default_file)

      # Priority of environment goes to lane called with ":<env>"
      # Then uses environment passed in through options ":<env>"
      env = nil
      if env_key.split('__').size > 1
        env = env_key.split('__')[1]
      elsif p_env
        # env = Fastlane::Actions.lane_context[ Fastlane::Actions::SharedValues::ENVIRONMENT ].to_s unless p_env
        env_key = lane_key + '__' + p_env
      end

      # Loads .env file for the environment
      if env
        env_file = File.join(Fastlane::FastlaneFolder.path || "", ".env.#{env}")
        Fastlane::Helper.log.info "Loading from '#{env_file}'".green
        Dotenv.overload(env_file)
      end

      env = p_env if p_env

      # Checking if the environment lane exists
      if env_key && lanes.include?(env_key)
        return platform, env_key.to_s, env
      else
        return platform, lane_key.to_s, env
      end
    end

    def lanes
      ff = Fastlane::FastFile.new(File.join(Fastlane::FastlaneFolder.path, 'Fastfile'))
      ff.runner.available_lanes
    end

  end

  def self.prepended(base)
    class << base
      prepend ClassMethods
    end  
  end

end
Fastlane::LaneManager.send(:prepend, FastlaneLaneManagerExtensions)

module Fastlane
  class FastFile
    prepend FastlaneEnvLanes::FastlaneFastFileExtensions
  end
end

