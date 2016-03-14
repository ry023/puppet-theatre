require 'mackerel'

module PuppetTheatre
  module Hosts
    class Mackerel < Base
      def each
        client.hosts(service: config.fetch(:service)).each do |host|
          yield host.name
        end
      end

      private

      def client
        @client ||= ::Mackerel::Client.new.tap do |client|
          client.configure do |c|
            c.api_key = config.fetch(:api_key)
          end
        end
      end
    end
  end
end
