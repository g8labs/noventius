module Nuntius

  class Report

    module Dsl

      module Filters

        def self.included(base)
          base.extend ClassMethods
          base.send :include, InstanceMethods
        end

        module ClassMethods

          RESERVED_FILTER_ARGS = %i(icon)

          FILTER_TYPES = %i(check_box color date datetime email month number phone radio_button range search
                            select telephone text_area text url week)

          def filters
            @filters ||= []
          end

          def filter(name, type, args = {})
            fail "FilterType: [#{type}] not yet implemented." unless valid_filter_type?(type)

            reserved_args, clean_args = split_filter_args(args)

            filters << {
              name: name.to_sym,
              type: type,
              args: clean_args,
              options: reserved_args || {}
            }

            define_filter_accessors(name, type)
          end

          protected

          def split_filter_args(args)
            clean_args = args.except(*RESERVED_FILTER_ARGS)
            reserved_args = args.except(*clean_args.keys)
            [reserved_args, clean_args]
          end

          def valid_filter_type?(type)
            FILTER_TYPES.include?(type.to_sym)
          end

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
