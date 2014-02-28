require 'calabash-cucumber/operations'
require 'calabash-cucumber/launcher'
require 'calabash-cucumber/launch/simulator_helper'
require 'sim_launcher'

module Calabash
  module Extras
    class IosRunner

      include Calabash::Cucumber::Core
      include Calabash::Cucumber::Operations

      def initialize(config)
        @config = config

        ENV['DEVICE'] = @config['DEVICE']
        ENV['PROJECT_DIR'] = @config['PROJECT_DIR']
        ENV['DEVICE_ENDPOINT'] = @config['DEVICE_ENDPOINT']
        ENV['BUNDLE_ID'] = @config['BUNDLE_ID']
      end

      def start
        reinstall_app
      end

      def reinstall_app
        calabash_launcher = Calabash::Cucumber::Launcher.new
        calabash_launcher.reset_app_jail
        start_test_server_in_background

        reinstall_hook if defined? self.reinstall_hook
      end
    end
  end
end
