module Slappy
  module SlackAPI
    class Base
      include Findable

      def ==(other)
        return false unless other.instance_of? self.class
        other.id == id
      end
    end
  end
end
