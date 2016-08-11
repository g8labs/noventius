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

        rows_by_date = group_rows_by_date(report, rows)

        start_date = rows_by_date.keys.min
        end_date = rows_by_date.keys.max

        empty_row = build_empty_row(report)

        build_range(start_date, end_date).map do |value|
          rows_by_date.fetch(value, [value].concat(empty_row))
        end
      end

      private

      def group_rows_by_date(report, rows)
        column_index = get_column_index(report, rows.first.is_a?(Hash))

        rows.inject({}) do |result, row|
          row[column_index] = parse_date_column(row[column_index])
          result.merge(row[column_index].to_i => row)
        end
      end

      def parse_date_column(value)
        if DATE_STEPS.include?(@step)
          if value.is_a?(String)
            Time.zone.parse(value).in_time_zone(@time_zone)
          else
            Time.zone.at(value).in_time_zone(@time_zone)
          end
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

      def build_empty_row(report)
        Array.new(report.columns.count - 1, '')
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
        end.map { |date| parse_date_column(date) }
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
