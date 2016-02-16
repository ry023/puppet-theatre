require 'erb'

module PuppetTheatre
  module Reporters
    class Html < Base
      Template = ERB.new(IO.read(File.join(File.dirname(__FILE__), 'html.erb')), nil, '-')

      class RenderData
        def initialize(results, timestamp)
          @results = results
          @timestamp = timestamp
        end
      end

      def call(env, results)
        timestamp = Time.now
        filename = "#{timestamp.strftime('%Y%m%dT%H%M%S')}.html"

        IO.write(File.join(config.fetch(:path), filename), render(results, timestamp))

        uri = URI.join(config.fetch(:uri), filename)
        env.notify("Report: #{uri}")
      end

      private

      def render(results, timestamp)
        RenderData.new(results, timestamp).instance_eval { Template.result(binding) }
      end
    end
  end
end
