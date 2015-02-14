module FastlaneFastFileExtensions
  def lane(key, env=nil, &block)
    key = (key.to_s + '__' + env.to_s).to_sym if env
    super key, &block
  end
end

module FastlaneRunnerExtensions
  def execute(key)
    env = Fastlane::Actions.lane_context[ Fastlane::Actions::SharedValues::ENVIRONMENT ]
    env_key = (key.to_s + '__' + env.to_s).to_sym if env
    
    begin
      super env_key
    rescue
      super key
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