module Noventius

  module ColumnsHelper

    def column_table_header_tag(report, column)
      options = column.html_options.deep_merge(colspan: column.html_options.fetch(:colspan, 1),
                                               rowspan: column.html_options.fetch(:rowspan, 1),
                                               class:   class_for_column_header(column),
                                               data:    data_for_column_header(column, report))

      content_tag(:th, column.label, options)
    end

    def number_of_header_levels(columns)
      columns.map(&:depth).max
    end

    def header_columns_for_level(columns, level)
      if level == 0
        columns
      else
        columns.select { |column| column.is_a?(ColumnsGroup) }
          .flat_map { |column| column.columns_for_level(level) }
      end
    end

    def class_for_column_header(column)
      css_class = if column.is_a?(Column)
                    'column-header'
                  elsif column.is_a?(ColumnsGroup)
                    'column-group-header'
                  end

      [column.html_options[:class], css_class].compact.join(' ')
    end

    def data_for_column_header(column, report)
      if column.is_a?(Column)
        { type: column.type(report) }
      elsif column.is_a?(ColumnsGroup)
        {}
      end
    end

  end

end
