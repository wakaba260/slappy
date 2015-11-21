module Slappy
  module Listener
    module Targettable
      include Slappy::Debuggable

      def target?(event)
        target.valid? event
      end

      def target
        @target ||= Target.new
      end

      private

      class Target
        def valid?(event)
          return true if channel.blank? && user.blank?

          result = []

          result << false unless validation(:channel, event)
          result << false unless validation(:user, event)

          result.blank?
        end

        def validation(target, event)
          return true if send(target).compact.blank?
          unless send(:list, target).include? event.send target
            Debug.log "Message from restrict #{target}(expect: #{target_names(target)})"
            return false
          end
          true
        end

        def channel=(value)
          value = [value] unless value.instance_of? Array
          @channel = value
        end

        def list(target)
          send(target).each_with_object([]) do |t, result|
            result << Slappy::SlackAPI.find(t)
          end
        end

        def channel
          @channel ||= []
        end

        def target_names(target)
          send(target).join(',')
        end

        def user=(value)
          value = [value] unless value.instance_of? Array
          @user = value
        end

        def user
          @user ||= []
        end
      end
    end
  end
end
