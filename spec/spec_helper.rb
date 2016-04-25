$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'puppet_theatre'
require 'timecop'
require 'pathname'
require 'tmpdir'

shared_context with_tmpdir: true do

  attr_reader :tmpdir

  around do |example|
    Dir.mktmpdir do |dir|
      @tmpdir = Pathname.new(dir)
      example.run
    end
  end

end
