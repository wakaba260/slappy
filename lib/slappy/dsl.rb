module Slappy
  module DSL
    def self.delegate(*methods)
      methods.each do |method_name|
        define_method(method_name) do |*args, &block|
          return super(*args, &block) if respond_to? method_name
          Slappy.send method_name, *args, &block
        end
      end
    end

    delegate :hello, :hear, :say, :start
  end
end

include Slappy::DSL
