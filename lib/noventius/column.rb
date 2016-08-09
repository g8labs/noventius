module Noventius

  class Column

    TYPES = %i(string integer float datetime date)

    attr_reader :name, :type, :label

    # rubocop:disable Metrics/CyclomaticComplexity
    def initialize(name, type, options = {})
      fail ArgumentError, "ColumnType: [#{type}] not yet implemented." unless TYPES.include?(type.to_sym)

      @name = name.to_sym
      @type = type.to_sym
      @label = options.delete(:label) || @name.to_s
      @label = instance_exec(&@label) if @label.is_a?(Proc)
      @default_value = options[:default_value] || default_value_for_type
      @value = options[:value] || default_value_block(@name, @default_value)
      @options = options
      @children = options[:children] || []
    end
    # rubocop:enable Metrics/CyclomaticComplexity

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

  end

end
