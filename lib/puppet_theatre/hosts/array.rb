module PuppetTheatre
  module Hosts
    class Array < Base
      def each(&block)
        config.fetch(:hosts).each(&block)
      end
    end
  end
end
