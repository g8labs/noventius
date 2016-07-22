module Nuntius

  module PostProcessors

    class DateRanges

      STEPS = %i(day month dow hour moy)

      def initialize(column_index_or_name, step, time_zone = 'America/Montevideo')
        fail ArgumentError, "Step not supported [#{step}]." unless STEPS.include?(step.to_sym)

        @column_index_or_name = column_index_or_name
        @step = step.to_sym
        @time_zone = time_zone
      end

      def process(report, rows)
        rows_by_date = group_rows_by_date(report, rows)

        start_date = rows_by_date.keys.min
        end_date = rows_by_date.keys.max

        empty_row = build_empty_row(report)

        build_range(start_date, end_date).map do |range_item|
          rows_by_date.fetch(range_item.date, [range_item.date].concat(empty_row))
        end
      end

      private

      def group_rows_by_date(report, rows)
        column_index = get_column_index(report)

        rows.inject({}) do |result, row|
          row[column_index] = DateTime.parse(row[column_index]).in_time_zone(@time_zone)
          result.merge(row[column_index] => row)
        end
      end

      def get_column_index(report)
        if @column_index_or_name.is_a?(Integer)
          @column_index_or_name
        else
          report.column_index(@column_index_or_name)
        end
      end

      def build_empty_row(report)
        columns_count = report.columns.size
        [''] * (columns_count - 1)
      end

      def build_range(start_date, end_date)
        if @step == :day
          DayRange.new(start_date)..DayRange.new(end_date)
        elsif @step == :month
          MonthRange.new(start_date)..MonthRange.new(end_date)
        elsif @step == :hour
          HourRange.new(start_date)..HourRange.new(end_date)
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

      class HourRange < BaseRange

        def initialize(date)
          super
          @step = 1.hour
        end

      end

    end

  end

end
