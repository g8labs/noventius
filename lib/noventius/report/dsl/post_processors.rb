module Noventius

  class Report

    module Dsl

      module PostProcessors

        def self.included(base)
          base.extend ClassMethods
          base.send :include, InstanceMethods
        end

        module ClassMethods

          def post_processors
            @post_processors ||= []
          end

          def post_processor(post_processor, options = {})
            post_processors << [post_processor, options]
          end

        end

        module InstanceMethods

          def post_processors
            self.class.post_processors
          end

        end

      end

    end

  end

end
