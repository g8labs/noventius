# rubocop:disable all
module Noventius

  module FiltersHelper

    include Noventius::FilterWrappers

    RESERVED_OPTIONS = [:dependent]

    def filter_tag(filter, report, options = {})
      tag_options = set_current_filter_value(filter, report)
      tag_options = merge_filter_options(filter, options, tag_options)
      tag_options = add_filter_options(filter, report, tag_options)

      send(:"#{filter.type}_filter_tag", scope_name(filter.name), tag_options)
    end

    def class_for_filter_wrapper(filter)
      classes = ['form-group']

      if filter.type == :select
        classes << 'select-filter-wrapper'
      end

      classes.join(' ')
    end

    def class_for_filter(filter)
      classes = ['noventius-filter']

      unless filter.type == :select
        classes << 'form-control'
      end

      classes.join(' ')
    end

    def set_current_filter_value(filter, report)
      tag_options = filter.args.dup
      current_value = report.filter_params[filter.name]

      case filter.type
      when :select
        tag_options[:option_tags] = compile_select_option_tags(filter, report)
      when :check_box
        tag_options[:checked] = current_value == (tag_options[:value] || DEFAULT_CHECK_BOX_VALUE)
      when :radio_button
        tag_options[:checked] = current_value == (tag_options[:value] || DEFAULT_RADIO_BUTTON_VALUE)
      when :text_area
        tag_options[:content] = current_value || tag_options[:content]
      else
        tag_options[:value] = current_value || tag_options[:value]
      end

      tag_options
    end

    def compile_select_option_tags(filter, report)
      option_tags = filter.args[:option_tags]
      option_tags = option_tags.is_a?(Symbol) ? report.send(option_tags) : option_tags
      current_value = report.filter_params[filter.name]

      if filter.args[:dependent].present? && option_tags.is_a?(Hash)
        return ''
      elsif filter.args[:dependent].present?
        fail ArgumentError, 'when a dependent select option_tags can only be a Hash.'
      end

      if option_tags.is_a?(String)
        option_tags.html_safe
      elsif option_tags.is_a?(Array)
        if option_tags.size == 1 || option_tags.size == 2
          if option_tags.size == 2
            option_tags[1] = current_value || option_tags[1]
          else
            option_tags << current_value
          end
          options_for_select(*option_tags)
        elsif option_tags.size == 3 || option_tags.size == 4
          if option_tags.size == 4
            option_tags[3] = current_value || option_tags[3]
          else
            option_tags << current_value
          end
          options_from_collection_for_select(*option_tags)
        else
          fail ArgumentError, 'option_tags can only be a String, an Array(max size 4) or a Symbol.'
        end
      else
        fail ArgumentError, 'option_tags can only be a String, an Array(max size 4) or a Symbol.'
      end
    end

    protected

    def merge_filter_options(filter, options, tag_options)
      tag_options.delete_if { |k, _| RESERVED_OPTIONS.include?(k) }

      (tag_options[:options] ||= {}).each do |k, v|
        opt = options.delete(k)
        next unless opt

        case v.class.to_s
        when String.to_s
          v << ' ' << opt
        when Array.to_s
          v.concat(opt)
        when Hash.to_s
          v.merge!(opt)
        end
      end
      tag_options[:options].merge!(options)

      tag_options
    end

    def add_filter_options(filter, report, tag_options)
      tag_options = (tag_options || {}).dup
      tag_options[:options] ||= {}

      if filter.type == :select
        include_blank = (filter.args[:options] || {})[:include_blank]

        tag_options[:options].deep_merge!(data: { include_blank: include_blank })
      end

      if filter.type == :select && filter.args[:dependent].present?
        options = filter.args[:option_tags]
        options = options.is_a?(Symbol) ? report.send(options) : options
        current_value = report.filter_params[filter.name]

        options = options.inject({}) do |result, (key, value)|
          result.merge(Array(key).join('_!_') => value)
        end

        tag_options[:options].deep_merge!(disabled: true,
                                          data: { dependent: filter.args[:dependent],
                                                  options: options, current_value: current_value })
      end

      tag_options
    end

  end

end
# rubocop:enable all
