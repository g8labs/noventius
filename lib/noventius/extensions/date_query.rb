module Noventius

  module Extension

    module DateQuery

      def self.included(base)
        base.extend ClassMethods
        base.send :include, InstanceMethods
      end

      module ClassMethods

      end

      module InstanceMethods

        # rubocop:disable Metrics/LineLength
        SQL_FUNCTIONS = {
          DateComponents::DAY           => "DATE_TRUNC('day', <%column%>::timestamptz AT TIME ZONE {time_zone})",
          DateComponents::MONTH         => "DATE_TRUNC('month', <%column%>::timestamptz AT TIME ZONE {time_zone})",
          DateComponents::DAY_OF_WEEK   => 'EXTRACT(DOW from <%column%>::timestamptz AT TIME ZONE {time_zone})::integer',
          DateComponents::HOUR          => 'EXTRACT(HOUR from <%column%>::timestamptz AT TIME ZONE {time_zone})::integer',
          DateComponents::MONTH_OF_YEAR => 'EXTRACT(MONTH from <%column%>::timestamptz AT TIME ZONE {time_zone})::integer'
        }
        # rubocop:enable Metrics/LineLength

        # The different component that can be extracted from a timestamp
        #
        # @return [Hash] The components
        def date_extract_options
          [
            {
              'Day'           => DateComponents::DAY,
              'Month'         => DateComponents::MONTH,
              'Day of week'   => DateComponents::DAY_OF_WEEK,
              'Hour of day'   => DateComponents::HOUR,
              'Month of year' => DateComponents::MONTH_OF_YEAR
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
          sql_function = SQL_FUNCTIONS[component.to_sym].dup

          Class.new(OpenStruct) {
            include Noventius::Report::Interpolator
          }.new(column: column, time_zone: time_zone).interpolate(sql_function)
        end

      end

    end

  end

end
