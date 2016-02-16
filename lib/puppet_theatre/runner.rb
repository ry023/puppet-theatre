module PuppetTheatre
  class Runner
    def initialize(&block)
      @config = Config.new.tap {|o| o.instance_eval(&block) }
    end

    def config(s)
      @config.public_send(s)
    end

    class Config
      attr_accessor :hosts, :checkers, :reporters, :notifiers

      def initialize
        @hosts = nil
        @checkers = {}
        @reporters = {}
        @notifiers = {}
      end

      def hosts_from(klass, opts = {})
        klass = Hosts.find_class(klass) if klass.is_a?(Symbol)
        obj = klass.is_a?(Class) ? klass.new(opts) : klass.call(*args)
        @hosts = obj
      end

      def add_checker(klass, opts = {})
        klass = Checkers.find_class(klass) if klass.is_a?(Symbol)
        obj = klass.is_a?(Class) ? klass.new(opts) : klass.call(*args)
        @checkers[opts[:name] || klass.name.split('::')[-1]] = obj
      end

      def add_reporter(klass, opts = {})
        klass = Reporters.find_class(klass) if klass.is_a?(Symbol)
        obj = klass.is_a?(Class) ? klass.new(opts) : klass.call(*args)
        @reporters[opts[:name] || klass.name.split('::')[-1]] = obj
      end

      def add_notifier(klass, opts = {})
        klass = Notifiers.find_class(klass) if klass.is_a?(Symbol)
        obj = klass.is_a?(Class) ? klass.new(opts) : klass.call(*args)
        @notifiers[opts[:name] || klass.name.split('::')[-1]] = obj
      end
    end

    class ExceptionalResult
      def initialize(exn)
        @exn = exn
      end

      def alert?
        true
      end

      def details
        @exn.backtrace
      end

      def summary
        @exn.to_s
      end
    end

    def call
      results = Hash.new {|h, k| h[k] = {} }

      config(:hosts).sort.map do |host|
        config(:checkers).each_pair do |name, checker|
          result =
            begin
              checker.call(self, host)
            rescue
              ExceptionalResult.new($!)
            end

          results[host][name] = result if result
        end
      end

      config(:reporters).each do |_, reporter|
        begin
          reporter.call(self, results)
        rescue
          warn $!
        end
      end
    end

    alias_method :run, :call

    def notify(msg)
      config(:notifiers).each do |_, notifier|
        begin
          notifier.call(self, msg)
        rescue
          warn $!
        end
      end
    end
  end
end
