module Calabash
  module Extras
    module PageObjectComparator
      def name
        self.class.name.rpartition('::').last
      end

      def ==(other)
        name == other.name
      end

      def eql?(other)
        name == other.name
      end

      def hash
        name.hash
      end

      def to_s
        name
      end
    end
  end
end