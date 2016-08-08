module Noventius

  module FilterWrappers

    DEFAULT_CHECK_BOX_VALUE = '1'
    DEFAULT_RADIO_BUTTON_VALUE = false

    def self.included(base)
      base.extend self
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

  end

end
