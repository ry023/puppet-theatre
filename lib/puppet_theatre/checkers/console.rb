module PuppetTheatre
  module Checkers
    class Console < Base
      def call(env, host)
        puts "Checking #{host}..."

        return nil
      end
    end
  end
end
