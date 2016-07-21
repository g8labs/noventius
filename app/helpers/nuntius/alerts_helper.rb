module Nuntius

  module AlertsHelper

    ALERT_TYPES = [:success, :info, :warning, :danger] unless const_defined?(:ALERT_TYPES)

    def flash_alert(options = {})
      flash_messages = []
      flash.each do |type, message|
        # Skip empty messages, e.g. for devise messages set to nothing in a locale file.
        next if message.blank?

        type = transform_type(type)

        next unless ALERT_TYPES.include?(type)

        tag_options = options_for_type(options, type)

        close_button = content_tag(:button,           raw('&times;'),
                                   type:              'button',
                                   class:             'close',
                                   'data-dismiss' =>  'alert')

        Array(message).each do |msg|
          text = content_tag(:div, close_button + msg, tag_options)
          flash_messages << text if msg
        end
      end
      flash_messages.join("\n").html_safe
    end

    def transform_type(type)
      case type
      when :notice then :success
      when :alert, :error then :danger
      else type
      end
    end

    def options_for_type(options, type)
      tag_class = options.extract!(:class)[:class]

      { class: "alert fade in alert-#{type} #{tag_class}" }.merge(options)
    end

  end

end
