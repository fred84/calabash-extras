module Calabash
  module Extras
    class ApplicationHandler

      def initialize(config)
        @conf = config
        ENV['SCREENSHOT_PATH'] = @conf['screen_shot_dir']
        start_device unless defined? @@device
      end

      def page (clz, *args)
        @@device.page(clz, *args)
      end

      def reinstall
        @@device.reinstall_app
      end

      def device
        @@device
      end

      private

      def start_device
        case @conf['os']
          when 'android'
            require 'android_runner'
            @@device = Calabash::Extras::AndroidRunner.new(@conf['android'])
          when 'ios'
            require 'ios_runner'
            @@device = Calabash::Extras::IosRunner.new(@conf['ios'])
          else
            raise 'Unsupported os type: "%s"' % @conf['os']
        end

        @@device.start
      end
    end
  end
end
