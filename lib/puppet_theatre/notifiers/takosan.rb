require 'takosan'

module PuppetTheatre
  module Notifiers
    class Takosan < Base
      def call(env, s)
        %w[url channel name icon].each do |t|
          ::Takosan.send("#{t}=", config[t.to_sym])
        end
        ::Takosan.privmsg(s)
      end
    end
  end
end
