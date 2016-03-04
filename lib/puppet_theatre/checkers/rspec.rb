require 'json'
require 'open3'
require 'shellwords'

module PuppetTheatre
  module Checkers
    class Rspec < Base

      class Result
        def initialize(result)
          @result = JSON.parse(result)
        end

        def alert?
          failure_count > 0
        end

        def summary
          if failure_count > 0
            "Failed (failed=#{failure_count}, total=#{example_count})"
          else
            "OK (failed=0, total=#{example_count})"
          end
        end

        def details
          @result['examples'].map {|example|
            if example['status'] == 'failed'
              "%s:%s %s" % [
                [example['file_path'], example['line_number']].join(':'),
                example['full_description'],
              ]
            end
          }.compact
        end

        private

        def failure_count
          @result['summary']['failure_count']
        end

        def example_count
          @result['summary']['example_count']
        end
      end

      def call(env, host)
        Dir.chdir(workdir(host)) do
          Bundler.with_clean_env do
            stdout, stderr, status = Open3.capture3(environment(host), command(host))
            return Result.new(stdout)
          end
        end
      end

      private

      def workdir(host)
        config[:workdir] || '.'
      end

      def environment(host)
        config[:env] || {}
      end

      def rspec_args(host)
        config[:args] || {}
      end

      def command(host)
        cmd = []
        cmd.push(config[:bundler], 'exec') if config[:bundler]
        cmd.push('rspec')

        rspec_args(host).each_pair do |k, v|
          cmd.push("--#{k}", v)
        end

        [
          %{tmp=$(mktemp)},
          %{#{cmd.shelljoin} --format json --out "$tmp" >/dev/null 2>&1},
          %{cat "$tmp"},
        ].join(?;)
      end
    end
  end
end
