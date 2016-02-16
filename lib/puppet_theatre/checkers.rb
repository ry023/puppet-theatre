require 'sshkit'
require_relative 'configurable'
require_relative 'findable'

module PuppetTheatre
  module Checkers
    extend Findable

    class Base
      include SSHKit::DSL
      include Configurable
    end

    def self.find_class(name)
      super(name, self, 'puppet_theatre/checkers')
    end
  end
end
