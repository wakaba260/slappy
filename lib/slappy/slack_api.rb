module Slappy
  module SlackAPI
    def self.find(value)
      [:Channel, :Group, :Direct, :User].each do |klass|
        klass = "Slappy::SlackAPI::#{klass}".constantize
        result = (klass.find(id: value) || klass.find(name: value))
        return result if result
      end
      nil
    end
  end
end
