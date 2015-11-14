module Slappy
  module SlackAPI
    module Findable
      extend ActiveSupport::Concern
      extend Forwardable

      def_delegators :@data, :method_missing, :respond_to?

      def initialize(data)
        @data = Hashie::Mash.new data
      end

      module ClassMethods
        attr_reader :list_name, :api_name

        def api_name=(api_name)
          @api_name = api_name
        end

        def list_name=(list_name)
          @list_name = list_name
        end

        def list(options = {})
          api_name    = self.api_name || name.split('::').last.downcase + 's'
          list_name   = self.list_name || api_name
          method_name = "#{api_name}_list"

          Slack.send(method_name, options)[list_name].map { |data| new(data) }
        end

        def find(arg)
          return find_by_keyword(arg) if arg.instance_of? Hash
          find id: arg
        end

        def find_by_keyword(hash)
          hash.map { |key, value| list.find { |obj| obj.send(key) == value } }.first
        end
      end
    end
  end
end
