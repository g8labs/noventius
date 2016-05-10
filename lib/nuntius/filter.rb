module Nuntius

  class Filter

    RESERVED_ARGS = %i(icon)
    TYPES = %i(check_box color date datetime email month number phone radio_button range search select
               telephone text_area text url week)

    attr_reader :name, :type, :args, :options

    def initialize(name, type, dirty_args = {})
      fail ArgumentError, "FilterType: [#{type}] not yet implemented." unless TYPES.include?(type.to_sym)

      @name = name.to_sym
      @type = type.to_sym
      @args = clean_args(dirty_args)
      @options = reserved_args(dirty_args)
    end

    def to_js
      {
        "#{name}" => {
          type: type,
          options: options
        }
      }
    end

    def deep_dup
      Marshal.load(Marshal.dump(self))
    end

    protected

    def reserved_args(args)
      args.except(*clean_args(args).keys) || {}
    end

    def clean_args(args)
      args.except(*RESERVED_ARGS) || {}
    end

  end

end
