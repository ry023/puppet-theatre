require 'puppet_theatre/version'
require 'puppet_theatre/hosts'
require 'puppet_theatre/checkers'
require 'puppet_theatre/reporters'
require 'puppet_theatre/notifiers'
require 'puppet_theatre/runner'

module PuppetTheatre
  def self.configure(&block)
    Runner.new(&block)
  end

  def self.run(&block)
    configure(&block).run
  end
end
