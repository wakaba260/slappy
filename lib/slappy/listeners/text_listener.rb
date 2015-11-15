module Slappy
  module Listener
    class TextListener < Base
      def pattern
        return /#{@pattern}/ if @pattern.instance_of? String
        @pattern
      end
    end
  end
end
