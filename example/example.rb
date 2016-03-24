#!/usr/bin/env ruby
require 'bundler/setup'
require 'puppet_theatre'

module PuppetTheatre::Checkers

  # exmaple of custom checker
  class Serverspec < find_class(:rspec)
    def rspec_args(host)
      super.merge(
        'pattern' => "spec/#{role(host)}/**/{,*/}**/*_spec.rb"
      )
    end

    def environment(host)
      super.merge(
        'TARGET_HOST' => host,
      )
    end

    private

    def shorthost(host)
      host.split('.')[0]
    end

    def role(host)
      shorthost(host).gsub(/\d+\z/, '')
    end
  end
end

PuppetTheatre.run do |c|
  c.hosts_from :array, hosts: ['www1.example.com', 'www2.example.com']

  c.add_checker :puppet_noop
  c.add_checker :serverspec, bundler: '/usr/local/bin/bundler', workdir: '/var/app/serverspec'

  c.add_reporter :summary
  c.add_reporter :html, path: '/srv/puppet_theatre', uri: 'https://status.example.com/'

  c.add_notifier :console
end
