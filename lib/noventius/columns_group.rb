module Noventius

  class ColumnsGroup

    attr_reader :name, :columns, :label

    def initialize(name, columns, options = {})
      @name = name.to_sym
      @columns = columns
      @label = options.delete(:label) || @name.to_s
      @label = instance_exec(&@label) if @label.is_a?(Proc)
      @options = options
    end

    def html_options
      @options[:html_options] || {}
    end

    def deep_dup
      Marshal.load(Marshal.dump(self))
    end

    def depth
      1 + (@columns.map(&:depth).max || 0)
    end

    def columns_for_level(level)
      if level == 1
        @columns
      else
        @columns.select { |column| column.is_a?(ColumnsGroup) }
          .flat_map { |child| child.columns_for_level(level - 1) }
      end
    end

  end

end
