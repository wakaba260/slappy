module Slappy
  module Commands
    class Run
      class InvalidPathError < StandardError; end

      def call
        load_config
        load_scripts
        Slappy.start
      rescue InvalidPathError => e
        puts TermColor.parse "<red>Error:</red> #{e.message}"
      end

      private

      def load_config
        file = File.expand_path Slappy.configuration.config_file_path, Dir.pwd
        begin
          require file
        rescue LoadError
          raise InvalidPathError.new, "file #{file} not found"
        end
      end

      def load_scripts
        script_dir = Slappy.configuration.scripts_dir_path

        unless FileTest.directory? script_dir
          message = "directory #{script_dir} not found"
          fail InvalidPathError.new, message
        end

        script_dir = "./#{script_dir}" unless script_dir.match(%r{"./"})
        Dir.glob("#{script_dir}/**/*.rb").each do |file|
          block = proc { require file }
          block.call
        end
      end
    end
  end
end
