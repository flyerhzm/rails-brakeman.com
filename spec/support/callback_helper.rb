module Support
  module CallbackHelper
    REPOSITORY_CALLBACKS = [:reset_authentication_token, :sync_github, :touch_last_build_at, :setup_github_hook]

    def skip_repository_callbacks(options={})
      if options[:only]
        Array(options[:only]).each do |callback|
          Repository.any_instance.stubs(callback)
        end
      elsif options[:except]
        (REPOSITORY_CALLBACKS - Array(options[:except])).each do |callback|
          Repository.any_instance.stubs(callback)
        end
      else
        REPOSITORY_CALLBACKS.each do |callback|
          Repository.any_instance.stubs(callback)
        end
      end
    end
  end
end
