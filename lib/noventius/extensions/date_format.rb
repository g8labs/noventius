module Noventius

  module Extension

    module DateFormat

      def self.included(base)
        base.extend ClassMethods
        base.send :include, InstanceMethods
      end

      module ClassMethods

      end

      module InstanceMethods

        # Format a date component value
        #
        # @param [#to_sym] component The component to format (see Noventius::DateComponents)
        # @param [Object] value The value to format
        #
        # @return [String]
        def format_date_component_value(component, value)
          return value unless component

          case component.to_sym
          when DateComponents::DAY_OF_WEEK
            format_day_of_week_value(value)
          when DateComponents::MONTH_OF_YEAR
            format_month_of_year_value(value)
          else
            value
          end
        end

        # Column type for a date component
        #
        # @param [#to_sym] component The component used on the column (see Noventius::DateComponents)
        #
        # @return [String]
        def date_component_type(component)
          case component.to_sym
          when DateComponents::DAY, DateComponents::MONTH then :datetime
          else :integer
          end
        end

        # Sort value used for a date component value
        #
        # @param [#to_sym] component The component to format (see Noventius::DateComponents)
        # @param [Object] value The value to format
        #
        # @return [String]
        def date_component_sort_value(component, value)
          case component.to_sym
          when DateComponents::DAY, DateComponents::MONTH then value.iso8601
          else value.to_i
          end
        end

        def format_day_of_week_value(value)
          I18n.t(:day_names, scope: :date)[value.to_i]
        end

        def format_month_of_year_value(value)
          I18n.t(:month_names, scope: :date)[value.to_i + 1]
        end

      end

    end

  end

end
