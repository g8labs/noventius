require 'csv'

module Noventius

  module Serializers

    class Csv

      def initialize(report)
        @report = report
      end

      def generate
        CSV.generate(force_quotes: true) do |csv|
          csv << headers
          rows.each { |row| csv << row }
        end
      end

      private

      def headers
        @report.columns.map do |column|
          column_with_prefix(column)
        end.flatten
      end

      def column_with_prefix(column, prefixes = [])
        if column.is_a?(Noventius::Column)
          [*prefixes, column.label].join(' ')
        else
          column.columns.map do |local_column|
            column_with_prefix(local_column, prefixes + [column.label])
          end.flatten
        end
      end

      def rows
        @report.rows.map do |row|
          row(row)
        end
      end

      def row(row)
        row.map do |cell|
          cell
        end
      end

    end

  end

end
