module Nuntius

  module Extension

    module DateQuery

      def self.included(base)
        base.extend ClassMethods
        base.send :include, InstanceMethods
      end

      module ClassMethods

      end

      module InstanceMethods

        SQL_FUNCTIONS = {
          'month' => "DATE_TRUNC('month', <%column%>::timestamptz AT TIME ZONE {time_zone})",
          'day' => "DATE_TRUNC('day', <%column%>::timestamptz AT TIME ZONE {time_zone})",
          'dow' => 'EXTRACT(DOW from <%column%>::timestamptz AT TIME ZONE {time_zone})::integer',
          'hour' => 'EXTRACT(HOUR from <%column%>::timestamptz AT TIME ZONE {time_zone})::integer',
          'moy' => 'EXTRACT(MONTH from <%column%>::timestamptz AT TIME ZONE {time_zone})::integer'
        }

        # The different component that can be extracted from a timestamp
        #
        # @return [Hash] The components
        def date_extract_options
          [
            {
              'Day' => 'day',
              'Month' => 'month',
              'Day of week' => 'dow',
              'Hour of day' => 'hour',
              'Month of year' => 'moy'
            }
          ]
        end

        # SQL function for the extraction of the desired timestamp component
        #
        # @param [String] component The Date component to extract
        # @param [String] column The column that has the timestamp
        # @param [String] time_zone The time_zone of the timestamp. Default: 'America/Montevideo'
        #
        # @return [String] The SQL function
        def date_extract(component:, column:, time_zone: 'America/Montevideo')
          sql_function = SQL_FUNCTIONS[component].dup

          Class.new(OpenStruct) {
            include Nuntius::Report::Interpolator
          }.new(column: column, time_zone: time_zone).interpolate(sql_function)
        end

      end

    end

  end

end
