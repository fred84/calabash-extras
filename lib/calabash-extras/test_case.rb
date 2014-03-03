require 'test/unit'
require 'yaml'
require 'application_handler'

module Calabash
  module Extras
    class TestCase < Test::Unit::TestCase
      def initialize(name)
        super name
        raise 'Config location not found in ENV' unless ENV.has_key? 'config_location'
        @conf = YAML.load_file ENV['config_location']
        @runner = Calabash::Extras::ApplicationHandler.new(@conf)
      end

      def page (clz, *args)
        @runner.page(clz, *args)
      end

      def reinstall_force #todo rename
        @runner.reinstall
      end

      def platform
        @conf['os']
      end
    end
  end
end