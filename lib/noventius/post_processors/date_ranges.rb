module Noventius

  module PostProcessors

    class DateRanges

      DAY           = :day
      MONTH         = :month
      HOUR          = :hour
      DAY_OF_WEEK   = :dow
      MONTH_OF_YEAR = :moy

      STEPS       = [DAY, MONTH, HOUR, DAY_OF_WEEK, MONTH_OF_YEAR]
      DATE_STEPS  = [DAY, MONTH]

      def initialize(column_index_or_name, step, time_zone = 'America/Montevideo')
        fail ArgumentError, "Step not supported [#{step}]." unless STEPS.include?(step.to_sym)

        @column_index_or_name = column_index_or_name
        @step = step.to_sym
        @time_zone = time_zone
      end

      def process(report, rows)
        return [] if rows.empty?

        hash_rows = rows.first.is_a?(Hash)

        column_index = get_column_index(report, hash_rows)
        rows_by_date = group_rows_by_date(rows, column_index)

        start_date = rows_by_date.keys.min
        end_date = rows_by_date.keys.max

        build_range(start_date, end_date).map do |value|
          empty_row = build_empty_row(report, value, column_index, hash_rows)

          rows_by_date.fetch(value, empty_row)
        end
      end

      private

      def group_rows_by_date(rows, column_index)
        rows.inject({}) do |result, row|
          row[column_index] = parse_date_column(row[column_index])
          result.merge(row[column_index] => row)
        end
      end

      def parse_date_column(value)
        if DATE_STEPS.include?(@step) && value.is_a?(String)
          Time.zone.parse(value)
        elsif DATE_STEPS.include?(@step)
          Time.zone.at(value)
        else
          value.to_i
        end
      end

      def get_column_index(report, hash_rows)
        if hash_rows
          @column_index_or_name.to_s
        elsif @column_index_or_name.is_a?(Integer)
          @column_index_or_name
        else
          report.column_index(@column_index_or_name)
        end
      end

      def build_empty_row(report, value, column_index, hash_rows)
        empty_row = if hash_rows
                      {}
                    else
                      Array.new(report.columns.count)
                    end

        empty_row[column_index] = value

        empty_row
      end

      def build_range(start_value, end_value)
        case @step
        when DAY
          (DayRange.new(start_value)..DayRange.new(end_value)).map(&:date)
        when MONTH
          (MonthRange.new(start_value)..MonthRange.new(end_value)).map(&:date)
        when HOUR
          0..23
        when DAY_OF_WEEK
          0..6
        when MONTH_OF_YEAR
          0..11
        else
          start_value..end_value
        end
      end

      class BaseRange

        include Comparable

        attr_reader :date

        def initialize(date)
          @date = date
        end

        def succ
          self.class.new(@date + @step)
        end

        def <=>(other)
          @date <=> other.date
        end

      end

      class DayRange < BaseRange

        def initialize(date)
          super
          @step = 1.day
        end

      end

      class MonthRange < BaseRange

        def initialize(date)
          super
          @step = 1.month
        end

      end

    end

  end

end
