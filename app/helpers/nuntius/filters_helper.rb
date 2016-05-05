module Nuntius

  module FiltersHelper

    SCOPE_KEY = :q

    DEFAULT_CHECK_BOX_VALUE = '1'
    DEFAULT_RADIO_BUTTON_VALUE = false

    def filter_tag(filter, report, options = {})
      merge_filter_options(filter, options)
      set_current_filter_value(filter, report)

      send("#{filter[:type]}_filter_tag", scoped_name(filter[:name]), filter[:args])
    end

    def set_current_filter_value(filter, report)
      current_value = report.filter_params[filter[:name]]

      case filter[:type]
      when :select
        filter[:args][:option_tags] = prepare_select_option_tags(filter, report)
      when :check_box
        filter[:args][:checked] = current_value == (filter[:args][:value] || DEFAULT_CHECK_BOX_VALUE)
      when :radio_button
        filter[:args][:checked] = current_value == (filter[:args][:value] || DEFAULT_RADIO_BUTTON_VALUE)
      when :text_area
        filter[:args][:content] = current_value || filter[:args][:content]
      else
        filter[:args][:value] = current_value || filter[:args][:value]
      end
    end

    def filter_value_field_name(filter_type)
      method("#{filter_type}_filter_tag").parameters[1][-1]
    end

    def check_box_filter_tag(name, value: DEFAULT_CHECK_BOX_VALUE, checked: false, options: {})
      check_box_tag(name, value, checked, options)
    end

    def color_filter_tag(name, value: nil, options: {})
      color_field_tag(name, value, options)
    end

    def date_filter_tag(name, value: nil, options: {})
      date_field_tag(name, value, options)
    end

    def datetime_filter_tag(name, value: nil, options: {})
      datetime_field_tag(name, value, options)
    end

    def email_filter_tag(name, value: nil, options: {})
      datetime_field_tag(name, value, options)
    end

    def month_filter_tag(name, value: nil, options: {})
      month_field_tag(name, value, options)
    end

    def number_filter_tag(name, value: nil, options: {})
      number_field_tag(name, value, options)
    end

    def phone_filter_tag(name, value: nil, options: {})
      phone_field_tag(name, value, options)
    end

    def radio_button_filter_tag(name, value: DEFAULT_RADIO_BUTTON_VALUE, checked: false, options: {})
      radio_button_tag(name, value, checked, options)
    end

    def range_filter_tag(name, value: nil, options: {})
      range_field_tag(name, value, options)
    end

    def search_filter_tag(name, value: nil, options: {})
      search_field_tag(name, value, options)
    end

    def select_filter_tag(name, option_tags: nil, options: {})
      select_tag(name, option_tags, options)
    end

    def telephone_filter_tag(name, value: nil, options: {})
      text_field_tag(name, value, options)
    end

    def text_area_filter_tag(name, content: nil, options: {})
      text_area_tag(name, content, options)
    end

    def text_filter_tag(name, value: nil, options: {})
      text_field_tag(name, value, options)
    end

    def time_filter_tag(name, value: nil, options: {})
      time_field_tag(name, value, options)
    end

    def url_filter_tag(name, value: nil, options: {})
      url_field_tag(name, value, options)
    end

    def week_filter_tag(name, value: nil, options: {})
      week_field_tag(name, value, options)
    end

    protected

    def scoped_name(name)
      "#{SCOPE_KEY}[#{name}]"
    end

    def merge_filter_options(filter, options)
      (filter[:args][:options] ||= {}).each do |k, v|
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
      filter[:args][:options].merge!(options)
    end

    def prepare_select_option_tags(filter, report)
      option_tags = filter[:args][:option_tags]
      option_tags = option_tags.is_a?(Symbol) ? report.send(option_tags) : option_tags
      current_value = report.filter_params[filter[:name]]

      if option_tags.is_a?(String)
        option_tags.html_safe
      elsif option_tags.is_a?(Array)
        if option_tags.size == 1 || option_tags.size == 2
          if option_tags.size == 2
            option_tags[1] = current_value || filter[:args][:option_tags]
          else
            option_tags << current_value
          end
          options_for_select(*option_tags)
        elsif option_tags.size == 3 || option_tags.size == 4
          if option_tags.size == 4
            option_tags[3] = current_value || filter[:args][:option_tags]
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

  end

end
