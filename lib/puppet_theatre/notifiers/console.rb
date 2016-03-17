module PuppetTheatre
  module Notifiers
    class Console < Base
      def call(msg)
        puts msg
      end
    end
  end
end
