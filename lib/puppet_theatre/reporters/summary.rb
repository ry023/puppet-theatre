module PuppetTheatre
  module Reporters
    class Summary < Base
      OK = "\u{2714}" # HEAVY CHECK MARK
      NG = "\u{2757}" # HEAVY EXCLAMATION MARK

      def call(env, results)
        summary = {}

        results.each do |host, checks|
          checks.each do |name, check|
            summary[name] ||= 0
            summary[name] += 1 if check.alert?
          end
        end

        message = summary.map {|name, failures|
          "%s: %s" % [name, failures > 0 ? NG + "(#{failures})" : OK]
        }.join('; ')

        env.notify(message)
      end
    end
  end
end
