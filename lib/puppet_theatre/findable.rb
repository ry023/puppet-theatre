module PuppetTheatre
  module Findable
    def find_class(name, mod, path)
      klsname = name.to_s.gsub(/(?:\A|_)./) {|s| s[-1].upcase }.intern
      begin
        return mod.const_get(klsname)
      rescue NameError
        require [path, name].join(?/)
        return mod.const_get(klsname)
      end
    end
  end
end
