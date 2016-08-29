module Noventius

  module CellsHelper

    def cell_tag(report, row, column)
      value = column.value(report, row)

      content_tag(:td, format_value(value), cell_tag_options(report, row, column))
    end

    def format_value(value)
      case value
      when Date, DateTime, Time
        l(value, format: :long)
      else
        value
      end
    end

    def cell_tag_options(report, row, column)
      {}.tap do |options|
        sort_value = column.sort_value(report, row)
        options[:data] = { text: sort_value } if sort_value
      end
    end

  end

end
