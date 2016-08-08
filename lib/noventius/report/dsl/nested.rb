module Noventius

  class Report

    module Dsl

      module Nested

        def self.included(base)
          base.extend ClassMethods
          base.send :include, InstanceMethods
        end

        module ClassMethods

          attr_reader :nested_options
          attr_reader :nested_report_class

          def nest_report(klass, options = {})
            @nested_report_class = klass
            @nested_options = options
          end

          def includes_nested?
            @nested_report_class != nil
          end

        end

        module InstanceMethods

          def nested_options
            self.class.nested_options
          end

          def enable_nested?
            return @enable_nested unless @enable_nested.nil?

            return false unless self.class.includes_nested?

            @enable_nested = nested_options.fetch(:if, true)
            @enable_nested = public_send(@enable_nested) if @enable_nested.is_a?(Symbol)
            @enable_nested = instance_exec(&@enable_nested) if @enable_nested.is_a?(Proc)

            @enable_nested
          end

          def build_nested_report(row)
            row ||= []

            nested_filters = nested_options[:filters] || filter_params
            nested_filters = public_send(nested_filters, row) if nested_filters.is_a?(Symbol)
            nested_filters = instance_exec(row, &nested_filters) if nested_filters.is_a?(Proc)

            self.class.nested_report_class.new(nested_filters)
          end

        end

      end

    end

  end

end
