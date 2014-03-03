require 'rubygems'
require 'net/telnet'
require 'calabash-android/operations'
require 'calabash-android/abase'

module Calabash
  module Extras
    class AndroidRunner

      include Calabash::Android::Operations

      attr_reader :default_device

      def initialize(config)
        @config = config
      end

      def start
        load Gem.bin_path('calabash-android', 'calabash-android')

        path = File.expand_path(@config['apk_path'])

        Emulator.launch(@config['emulator']) if @config['start_emulator']

        build_test_server_if_needed(path)
        set_default_device(Device.new(self, @config['name'], nil, path, test_server_path(path)))
      end

      def reinstall_app
        reinstall_apps
        sleep 1
        start_test_server_in_background
        reinstall_hook if defined? self.reinstall_hook
      end

      private

      def test_server_path(apk_file_path)
        @config['test_server_dir'] + "test_servers/#{checksum(apk_file_path)}_#{Calabash::Android::VERSION}.apk"
      end

      class Emulator
        def self.launch(config)
          inst = self.new(config)
          inst.kill_old
          inst.run
        end

        def initialize(config)
          @cfg = config
        end

        def run
          @pid = fork { exec(@cfg['run']) }
          sleep(@cfg['wait_for_emulator'])
          unlock
          sleep(@cfg['sleep_after_launch'])
        end

        def is_running?
          defined? @pid && !@pid.nil? && @pid > 0
        end

        def unlock
          emulator_cli = Net::Telnet::new('Host' => @cfg['host'], 'Port' => @cfg['port'])
          emulator_cli.puts('event send EV_KEY:KEY_MENU:1 EV_KEY:KEY_MENU:0')
          emulator_cli.close
        end

        def kill
          Process.kill('QUIT', @pid) if is_running?
        end

        def kill_old
          find_pids.each { |pid| Process.kill('QUIT', pid) }
        end

        protected

        def find_pids
          #TODO find all pids, not just one
          command = 'ps ax | grep "/opt/android_sdk/tools/emulator64-x86" | grep -v grep |awk \'{print $1}\''
          pid = %x(#{command})
          if pid != '' && pid.to_i > 0
            [pid.to_i]
          else
            []
          end
        end
      end
    end
  end
end


