module PuppetTheatre
  module Hosts
    class Getent < Base
      def each
        pattern = config.fetch(:pattern, //)
        IO.popen('getent hosts', 'r') do |f|
          f.each_line do |l|
            l.chomp.split[1..-1].each do |host|
              yield host if host =~ pattern
            end
          end
        end
      end
    end
  end
end
