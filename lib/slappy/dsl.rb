module Slappy
  module DSL
    extend Forwardable

    def_delegators :Slappy, :hello, :hear, :say, :start, :logger, :schedule, :monitor, :goodnight
  end
end

extend Slappy::DSL
