module PuppetTheatre
  module Notifiers
    class Console < Base
      def call(env, msg)
        puts msg
      end
    end
  end
end
