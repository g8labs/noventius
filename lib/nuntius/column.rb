module Nuntius

  class Column

    TYPES = %i(string integer float datetime date)

    attr_reader :name, :type, :label

    def initialize(name, type, options = {})
      fail ArgumentError, "ColumnType: [#{type}] not yet implemented." unless TYPES.include?(type.to_sym)

      @name = name.to_sym
      @type = type.to_sym
      @label = options.delete(:label) || @name.to_s
      @label = instance_exec(&@label) if @label.is_a?(Proc)
      @value = options[:value] || ->(rows) { rows[column_index(name.to_sym)] }
      @options = options
      @children = options[:children] || []
    end

    def html_options
      @options[:html_options] || {}
    end

    def value(report, row)
      if @value.is_a?(Proc)
        report.instance_exec(row, &@value)
      elsif @value.is_a?(Symbol)
        report.public_send(@value, row)
      else
        @value
      end
    end

    def depth
      1
    end

  end

end
