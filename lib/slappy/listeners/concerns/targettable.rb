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
          result = []

          return true if channel.blank? && user.blank?

          unless valid_channel?(event.channel)
            # rubocop:disable Metrics/LineLength
            Debug.log "Message from restrict channel(expect: #{channel.join(',')}, got: #{event.channel.name})"
            # rubocop:enable Metrics/LineLength
            result << false
          end

          unless valid_user?(event.user)
            # rubocop:disable Metrics/LineLength
            Debug.log "Message from restrict user(expect: #{user.join(',')}, got: #{event.user.name})"
            # rubocop:enable Metrics/LineLength
            result << false
          end

          result.blank?
        end

        def valid_user?(user)
          return true if self.user.compact.blank?
          user_list.include? user
        end

        def valid_channel?(channel)
          return true if self.channel.compact.blank?
          channel_list.include? channel
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
      end
    end
  end
end
