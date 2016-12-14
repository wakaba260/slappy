module Slappy
  module Brain
    class Base
      def set(key, value)
        data[key] = value
      end

      def get(key)
        data[key]
      end

      private

      def data
        @data ||= {}
      end
    end
  end
end
