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

          result << false unless valid_channel?(event.channel)
          result << false unless valid_user?(event.user)

          result.blank?
        end

        def valid_user?(user)
          return true if self.user.compact.blank?
          unless user_list.include? user
            Debug.log "Message from restrict user(expect: #{user_names})"
            return false
          end
          true
        end

        def valid_channel?(channel)
          return true if self.channel.compact.blank?
          unless channel_list.include? channel
            Debug.log "Message from restrict channel(expect: #{channel_names})"
            return false
          end
          true
        end

        def channel=(value)
          value = [value] unless value.instance_of? Array
          @channel = value
        end

        def channel
          @channel ||= []
        end

        def channel_list
          @channel.each_with_object([]) do |channel, result|
            result << Slappy::SlackAPI.find(channel)
          end
        end

        def channel_names
          channel.join(',')
        end

        def user
          @user ||= []
        end

        def user=(value)
          value = [value] unless value.instance_of? Array
          @user = value
        end

        def user_list
          @user.each_with_object([]) do |user, result|
            result << Slappy::SlackAPI.find(user)
          end
        end

        def user_names
          user.join(',')
        end
      end
    end
  end
end
