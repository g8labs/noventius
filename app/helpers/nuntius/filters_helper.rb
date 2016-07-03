# rubocop:disable all
module Nuntius

  module FiltersHelper

    include Nuntius::FilterWrappers

    def filter_tag(filter, report, options = {})
      merge_filter_options(filter, options)
      set_current_filter_value(filter, report)

      send(:"#{filter.type}_filter_tag", scope_name(filter.name), filter.args)
    end

    def class_for_filter_wrapper(filter)
      classes = ['form-group']

      if filter.type == :select
        classes << 'select-filter-wrapper'
      end

      classes.join(' ')
    end

    def class_for_filter(filter)
      classes = ['nuntius-filter']

      unless filter.type == :select
        classes << 'form-control'
      end

      classes.join(' ')
    end

    def set_current_filter_value(filter, report)
      filter_args = filter.args
      current_value = report.filter_params[filter.name]

      case filter.type
      when :select
        filter_args[:option_tags] = compile_select_option_tags(filter, report)
      when :check_box
        filter_args[:checked] = current_value == (filter_args[:value] || DEFAULT_CHECK_BOX_VALUE)
      when :radio_button
        filter_args[:checked] = current_value == (filter_args[:value] || DEFAULT_RADIO_BUTTON_VALUE)
      when :text_area
        filter_args[:content] = current_value || filter_args[:content]
      else
        filter_args[:value] = current_value || filter_args[:value]
      end
    end

    def compile_select_option_tags(filter, report)
      option_tags = filter.args[:option_tags]
      option_tags = option_tags.is_a?(Symbol) ? report.send(option_tags) : option_tags
      current_value = report.filter_params[filter.name]

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

    def merge_filter_options(filter, options)
      (filter.args[:options] ||= {}).each do |k, v|
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
      filter.args[:options].merge!(options)
    end

  end

end
# rubocop:enable all
