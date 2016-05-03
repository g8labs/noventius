module Nuntius

  module CoreExtensions

    module Hash

      module Traverse

        # Calculates de depth of a Hash
        #
        # @return [Integer] the hash's depth
        def depth
          1 + (each_value.map do |val|
            if val.is_a?(::Hash)
              val.depth
            elsif val.is_a?(::Array)
              (val.map(&:depth).max || 0)
            else
              0
            end
          end.max || 0)
        end

        # Returns all the keys existing at a given depth
        #
        # @param [Integer] the depth of the keys to retrive
        # @return [Array] all the keys at the given depth
        def nth_level_children(n, c = 0)
          return nil if n < c += 1
          return each_pair.to_a if n == c

          each_pair.flat_map do |pair|
            val = pair.last
            if val.is_a?(::Hash)
              val.nth_level_children(n, c)
            elsif val.is_a?(::Array)
              val.collect { |el| el.nth_level_children(n, c) }
            end
          end - [nil]
        end

      end

    end

  end

end
