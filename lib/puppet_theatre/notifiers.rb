require_relative 'configurable'
require_relative 'findable'

module PuppetTheatre
  module Notifiers
    extend Findable

    class Base
      include Configurable
    end

    def self.find_class(name)
      super(name, self, 'puppet_theatre/notifiers')
    end
  end
end
