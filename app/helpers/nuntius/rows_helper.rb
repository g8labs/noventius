module Nuntius

  module RowsHelper

    def row_tag(row, report, &block)
      options = { data: data_for_row(row, report) }

      content_tag(:tr, options, &block)
    end

    def data_for_row(row, report)
      return unless report.enable_nested?

      { nested: { url: nested_report_path(name: report.class.name),
                  row: row,
                  filters: { q: report.filter_params } } }
    end

  end

end
