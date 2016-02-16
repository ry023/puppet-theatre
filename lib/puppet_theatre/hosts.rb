require_relative 'configurable'
require_relative 'findable'

module PuppetTheatre
  module Hosts
    extend Findable

    class Base
      include Enumerable
      include Configurable
    end

    def self.find_class(name)
      super(name, self, 'puppet_theatre/hosts')
    end
  end
end
