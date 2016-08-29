module Noventius

  class Column

    TYPES = %i(string integer float datetime date)

    attr_reader :name, :label

    def initialize(name, type, options = {})
      @name = name.to_sym
      @type = type
      @label = options.delete(:label) || @name.to_s
      @label = instance_exec(&@label) if @label.is_a?(Proc)
      @default_value = options[:default_value] || default_value_for_type
      @value = options[:value] || default_value_block(@name, @default_value)
      @sort_value = options[:sort_value]
      @options = options
      @children = options[:children] || []
    end

    def html_options
      @options[:html_options] || {}
    end

    def type(report)
      if @type.is_a?(Proc)
        report.instance_exec(&@type)
      else
        @type
      end.tap do |type|
        fail ArgumentError, "ColumnType: [#{type}] not yet implemented." unless TYPES.include?(type.to_sym)
      end
    end

    def value(report, row)
      call_method_or_proc(report, @value, row)
    end

    def sort_value(report, row)
      return unless @sort_value

      call_method_or_proc(report, @sort_value, row)
    end

    def depth
      1
    end

    private

    def default_value_block(name, default_value)
      lambda do |row|
        if row.is_a?(Hash)
          row[name.to_s] || row[name.to_sym]
        else
          row[column_index(name.to_sym)]
        end || default_value
      end
    end

    def default_value_for_type
      case @type
      when :integer         then 0
      when :float           then 0.0
      else ''
      end
    end

    def call_method_or_proc(report, method_or_proc, *args)
      if method_or_proc.is_a?(Proc)
        report.instance_exec(*args, &method_or_proc)
      elsif method_or_proc.is_a?(Symbol)
        report.public_send(method_or_proc, *args)
      else
        method_or_proc
      end
    end

  end

end
