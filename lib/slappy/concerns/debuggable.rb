module Slappy
  module Debuggable
    def self.included(klass)
      mod = Module.new do
        define_singleton_method :log do |message|
          Slappy.logger.try(:debug, "[#{klass.name}] #{message}")
        end
      end
      klass.const_set(:Debug, mod)
    end
  end
end
