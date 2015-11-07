module Slappy
  module DSL
    extend Forwardable

    def_delegators :Slappy, :hello, :hear, :say, :start
  end
end

extend Slappy::DSL
