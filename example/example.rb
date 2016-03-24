#!/usr/bin/env ruby
require 'bundler/setup'
require 'puppet_theatre'

PuppetTheatre.run do |c|
  c.hosts_from :array, hosts: ['www1.example.com', 'www2.example.com']

  c.add_checker :puppet_noop
  c.add_checker :rspec, bundler: '/usr/local/bin/bundler', workdir: '/var/app/serverspec'

  c.add_reporter :summary
  c.add_reporter :html, path: '/srv/puppet_theatre', uri: 'https://status.example.com/'

  c.add_notifier :console
end
