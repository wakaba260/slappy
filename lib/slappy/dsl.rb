module Slappy
  module DSL
    extend Forwardable

    def_delegators :Slappy, :hello, :hear, :say, :start, :logger
  end
end

extend Slappy::DSL
