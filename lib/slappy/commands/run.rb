module Slappy
  module Commands
    class Run
      class InvalidPathError < StandardError; end

      def call
        load_dsl
        load_config
        load_libs
        load_scripts
        Slappy.start
      rescue InvalidPathError => e
        puts TermColor.parse "<red>Error:</red> #{e.message}"
      end

      private

      def load_dsl
        return if Slappy.configuration.dsl == :disabled
        require 'slappy/dsl'
      end

      def load_config
        file = File.expand_path Slappy.configuration.config_file_path, Dir.pwd
        begin
          require file
        rescue LoadError
          raise InvalidPathError.new, "file #{file} not found"
        end
      end

      def load_directory(dir_name, &block)
        dir_path = Slappy.configuration.send dir_name.to_sym

        unless FileTest.directory? dir_path
          message = "directory #{dir_path} not found"
          fail InvalidPathError.new, message
        end

        dir_path = "./#{dir_path}" unless dir_path.match(%r{"./"})
        block.call(dir_path)
      end

      def load_libs
        load_directory(:lib_dir_path) do |lib_dir|
          Dir.glob("#{lib_dir}/**/*.rb").each do |file|
            require file
          end
        end
      end

      def load_scripts
        load_directory(:scripts_dir_path) do |script_dir|
          Dir.glob("#{script_dir}/**/*.rb").each do |file|
            block = proc { require file }
            block.call
          end
        end
      end
    end
  end
end
