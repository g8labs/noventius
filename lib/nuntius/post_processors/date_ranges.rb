module Nuntius

  module PostProcessors

    class DateRanges

      DATE_STEPS = %i(day month)
      STEPS = %i(day month hour dow moy)

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
          DateTime.parse(value).in_time_zone(@time_zone)
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
        columns_count = report.columns.size
        [''] * (columns_count - 1)
      end

      def build_range(start_value, end_value)
        case @step
        when :day
          (DayRange.new(start_value)..DayRange.new(end_value)).map(&:date)
        when :month
          (MonthRange.new(start_value)..MonthRange.new(end_value)).map(&:date)
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
