require 'takosan'

module PuppetTheatre
  module Notifiers
    class Takosan < Base
      def call(msg)
        %w[url channel name icon].each do |t|
          ::Takosan.send("#{t}=", config[t.to_sym]) if config[t.to_sym]
        end
        ::Takosan.privmsg(msg)
      end
    end
  end
end
