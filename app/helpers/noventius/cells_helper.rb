module Noventius

  module CellsHelper

    def cell_tag(value)
      content_tag(:td, format_value(value))
    end

    def format_value(value)
      case value
      when Date, DateTime, Time
        l(value, format: :long)
      else
        value
      end
    end

    def cell_for_row_column(report, row, column)
      column.value(report, row)
    end

  end

end
