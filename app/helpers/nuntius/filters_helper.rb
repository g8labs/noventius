module Nuntius

  module FiltersHelper

    SCOPE_KEY = :q

    def filter_tag(filter, _report, options = {})
      merge_filter_options(filter, options)
      send("#{filter[:type]}_filter_tag", scoped_name(filter[:name]), filter[:args])
    end

    def check_box_filter_tag(name, value: '1', checked: false, options: {})
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

    def radio_button_filter_tag(name, value: false, checked: false, options: {})
      radio_button_tag(name, value, checked, options)
    end

    def range_filter_tag(name, value: nil, options: {})
      range_field_tag(name, value, options)
    end

    def search_filter_tag(name, value: nil, options: {})
      search_field_tag(name, value, options)
    end

    def select_filter_tag(name, options_tags: nil, options: {})
      options_tags = @report.send(options_tags) if options_tags.is_a?(Symbol)

      options_tags = if options_tags.is_a?(Array) && options_tags.size == 2
                       options_for_select(*options_tags)
                     else
                       options_for_select(options_tags)
                     end

      select_tag(name, options_tags, options)
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

  end

end
