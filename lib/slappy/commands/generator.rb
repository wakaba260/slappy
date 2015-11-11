module Slappy
  module Commands
    class Generator
      def call(dir_name)
        dir_name = './' if dir_name.nil?
        dir_name += '/' if !dir_name.nil? && dir_name.split('').last != '/'
        @target_dir = dir_name

        mkdir target_dir unless @target_dir.nil?
        mkdir scripts_dir_path
        mkdir lib_dir_path

        copy template_script_path, scripts_dir_path
        copy config_file_path,     target_dir
      end

      private

      def target_dir
        File.expand_path @target_dir, Dir.pwd
      end

      def gem_root_dir
        File.expand_path '../../../../', __FILE__
      end

      def template_dir
        File.expand_path 'templates', gem_root_dir
      end

      def lib_dir_path
        File.expand_path Slappy.configuration.lib_dir_path, target_dir
      end

      def scripts_dir_path
        File.expand_path Slappy.configuration.scripts_dir_path, target_dir
      end

      def config_file_path
        File.expand_path Slappy.configuration.config_file_path, template_dir
      end

      def template_script_path
        File.expand_path 'example.rb', template_dir
      end

      def mkdir(path)
        generate(path) { FileUtils.mkdir path }
      end

      def copy(src, dest)
        path = File.expand_path File.basename(src), dest
        generate(path) { FileUtils.cp src, dest }
      end

      def status
        @messages = {
          create: TermColor.parse('<green>create</green>'),
          exist: TermColor.parse('<red>exist</red>')
        }
      end

      def generate(target, &block)
        if FileTest.exist? target
          result = status[:exist]
        else
          block.call
          result = status[:create]
        end

        put_result result, Pathname.new(target).relative_path_from(Pathname.new(Dir.pwd))
      end

      def put_result(result, target)
        puts "\t#{result}\t#{target}"
      end
    end
  end
end
