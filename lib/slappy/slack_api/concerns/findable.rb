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
        attr_reader :list_name, :api_name, :monitor_event, :monitor_registerd

        def api_name=(api_name)
          @api_name = api_name
        end

        def list_name=(list_name)
          @list_name = list_name
        end

        def monitor_event=(target)
          target = [target] unless target.instance_of? Array
          @monitor_event = target
        end

        def register_monitor
          return if @monitor_registerd
          @monitor_event.each do |event|
            Slappy.monitor event do
              @list = nil
            end
          end
          @monitor_registerd = true
        end

        def list(options = {})
          register_monitor
          @list = get_list(options) unless @list
          @list
        end

        def api_name
          @api_name || name.split('::').last.downcase + 's'
        end

        def list_name
          @list_name || api_name
        end

        def find(arg)
          return find_by_keyword(arg) if arg.instance_of? Hash
          find id: arg
        end

        def find_by_keyword(hash)
          hash.map { |key, value| list.find { |obj| obj.send(key) == value } }.first
        end

        private

        def get_list(options = {})
          method_name = "#{api_name}_list"

          options[:channel] = SlackAPI.find(options[:channel]).id if options[:channel]
          result = Slack.send(method_name, options)

          unless result['ok']
            exception = SlackError.new "Error message from slack (#{result['error']})"
            fail exception, exception.message
          end

          result[list_name].map { |data| new(data) }
        end
      end
    end
  end
end
