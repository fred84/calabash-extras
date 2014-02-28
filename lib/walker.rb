require 'priority_queue'

module Calabash
  module Extras
    class Walker

      MAX_INT = (2**(0.size * 8 -2) -1)

      def initialize(sleep_interval, matrix, log_callback)
        @sleep_interval = sleep_interval
        @matrix = matrix
        @logger = log_callback
      end

      def go(to)
        start_point = get_current_page

        @end_point = to

        raise 'Page "%s" does not exist' % [to] if @matrix[to].nil?

        return if start_point == @end_point

        path = find_path start_point, @end_point

        raise 'Unable to find path from "%s" to "%s"' % [start_point, @end_point] if path.last != @end_point

        resolve_path path
      end

      def last
        @end_point
      end

      def get_current_page
        sleep @sleep_interval
        all_page_elements = @matrix.keys.first.all_elements
        @matrix.keys.find { |page| page.match all_page_elements} || raise('Unable to determine current page') #todo replace with match method
      end

      def resolve_path(path)
        raise 'Empty path given' if path.empty?

        for i in 0..(path.length - 2)
          @logger.call('transition from %s to %s' % [path[i], path[i+1]])
          @matrix[path[i]][path[i+1]].call
        end
      end

      def find_path(start, finish)
        distances = {}
        previous = {}
        nodes = PriorityQueue.new

        @matrix.each_key do |point|
          if point == start
            distances[point] = 0
            nodes[point] = 0
          else
            distances[point] = MAX_INT
            nodes[point] = MAX_INT
          end
          previous[point] = nil
        end

        while nodes
          smallest = nodes.delete_min_return_key

          if smallest == finish
            path = []
            while previous[smallest]
              path.push(smallest)
              smallest = previous[smallest]
            end
            return path.push(start).reverse
          end

          if smallest.nil? or distances[smallest] == MAX_INT
            break
          end

          @matrix[smallest].each_key do |neighbor|
            alt = distances[smallest] + 1
            if alt < distances[neighbor]
              distances[neighbor] = alt
              previous[neighbor] = smallest
              nodes[neighbor] = alt
            end
          end
        end
        distances.inspect
      end
    end
  end
end