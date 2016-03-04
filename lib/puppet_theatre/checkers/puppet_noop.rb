require 'securerandom'
require 'shellwords'
require 'yaml'

module PuppetTheatre
  module Checkers
    class PuppetNoop < Base

      class Result
        def initialize(result)
          @result = self.class.load_plain_yaml(result)
        end

        def alert?
          status == 'failed' || out_of_sync_count > 0
        end

        def summary
          if status == 'failed'
            'Failed'
          elsif out_of_sync_count > 0
            "Out of sync (#{out_of_sync_count})"
          else
            'Up to date'
          end
        end

        def details
          @result['logs'].map {|log|
            "[%s] %s: %s" % [log['level'], log['source'], log['message']]
          }
        end

        private

        def status
          @result['status']
        end

        def out_of_sync_count
          @result['metrics']['resources']['values'].find {|r| r[0] == 'out_of_sync' }[2]
        end

        class TagStrip < Psych::Visitors::DepthFirst
          def initialize
            super ->(o) { o.tag = nil if o.respond_to?(:tag=); o }
          end
        end

        def self.load_plain_yaml(s)
          TagStrip.new.accept(YAML.parse(s)).to_ruby
        end
      end

      def call(env, host)
        cmd = [
          %{tmp=$(mktemp)},
          %{sudo puppet agent -t --noop --lastrunreport "$tmp" >/dev/null 2>&1},
          %{cat "$tmp"},
        ].join(?;)

        result = nil
        on(host) do |host|
          result = Result.new(capture(cmd))
        end

        result
      end

    end
  end
end
