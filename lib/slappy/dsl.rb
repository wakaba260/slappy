module Slappy
  module DSL
    extend Forwardable

    def_delegators :Slappy, :hello, :hear, :say, :start, :logger,
                   :schedule, :monitor, :goodnight, :respond, :brain
  end
end

extend Slappy::DSL
