module Nuntius

  class Report

    module Dsl

      module Filters

        def self.included(base)
          base.extend ClassMethods
          base.send :include, InstanceMethods
        end

        module ClassMethods

          def filters
            (@filters ||= []).sort_by! { |f| f.options[:priority] }
          end

          def filter(name, type, args = {})
            filters << Filter.new(name, type, args)
            define_filter_accessors(name, type)
          end

          protected

          def define_filter_accessors(name, _type)
            define_method(name) { filter_params[name] }
            define_method("#{name}=") { |value| filter_params[name] = value }
          end

        end

        module InstanceMethods

          attr_reader :filter_params

          def filters
            self.class.filters.deep_dup
          end

        end

      end

    end

  end

end
