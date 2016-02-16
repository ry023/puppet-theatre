module PuppetTheatre
  module Configurable
    attr_reader :config

    def initialize(config)
      @config = config || {}
    end
  end
end
