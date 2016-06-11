module Nuntius

  class Result

    extend Forwardable

    attr_reader :sql_result, :report

    delegate [:rows] => :sql_result

    def initialize(sql_result:, report:)
      @report = report
      @sql_result = sql_result
    end

    def columns
      report.respond_to?(:columns) ? report.columns : sql_result.columns
    end

    def complex_columns?
      columns.is_a?(::Hash)
    end

  end

end
