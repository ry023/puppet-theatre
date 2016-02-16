module PuppetTheatre
  module Reporters
    class Console < Base
      def call(env, results)
        results.each do |host, checks|
          puts ">> #{host}"
          checks.each do |name, check|
            puts "!! #{name}: #{check.summary}"
          end
        end
      end
    end
  end
end
