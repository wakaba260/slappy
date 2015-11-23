require 'json'

module Slappy
  module Brain
    class File < Base
      class AccessDeneidError < StandardError; end
      DEFAULT_INTERVAL = 1

      def initialize(path)
        super()
        @path = path
        @thread = Thread.new { sync }
        @thread.abort_on_exception = true
      end

      private

      attr_reader :path

      def data
        @data ||= read || {}
      end

      def read
        return if ::File.zero?(path)
        ::File.open(path) do |io|
          Marshal.load(io)
        end
      rescue EOFError
        nil
      end

      def write
        value = data.dup
        ::Timeout.timeout(interval, AccessDeneidError) do
          ::File.open(path, 'w') do |io|
            begin
              io.flock(::File::LOCK_EX)
              Marshal.dump(value, io)
            ensure
              io.flock(::File::LOCK_UN)
            end
          end
        end
      rescue AccessDeneidError
        raise AccessDeneidError, 'FIle access is timeout'
      end

      def sync
        loop do
          wait
          write
        end
      end

      def wait
        sleep(interval)
      end

      def interval
        (ENV['FILE_SAVE_INTERVAL'] || DEFAULT_INTERVAL).to_i
      end
    end
  end
end
