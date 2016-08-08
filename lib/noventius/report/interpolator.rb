module Noventius

  class Report

    module Interpolator

      def self.included(base)
        base.extend ClassMethods
        base.send :include, InstanceMethods
      end

      module ClassMethods

      end

      module InstanceMethods

        UNESCAPED_REGEX = /(<%\w+%>)+/
        UNESCAPED_VARIABLE_REGEX = /(?:<%)(\w+)(?:%>)/

        ESCAPED_REGEX = /({\w+})+/
        ESCAPED_VARIABLE_REGEX = /(?:{)(\w+)(?:})/

        # Interpolate the given text in the context of `self`
        #
        # Interpolated variables will try to call a method on `self` for obtaining the value.
        #
        # Two syntax are supported at the moment.
        #
        # Let's say we have a method called foo that return String 'bar'
        #
        # {foo} => 'bar'
        # <%foo%> => bar
        #
        # @param [String] text The text to interpolate
        # @return [String] The interpolated text
        def interpolate(text)
          return unless text

          # Interpolate escaped variables
          text.scan(ESCAPED_REGEX).flatten.each do |var|
            var_name = var.match(ESCAPED_VARIABLE_REGEX)[1]
            value = send(var_name.to_sym)

            text.gsub!(var, escape(value))
          end

          # Interpolate unescaped variables
          text.scan(UNESCAPED_REGEX).flatten.each do |var|
            var_name = var.match(UNESCAPED_VARIABLE_REGEX)[1]
            value = send(var_name.to_sym)

            text.gsub!(var, value)
          end

          text
        end

        protected

        def escape(value)
          if value.respond_to?(:map)
            "(#{value.map { |v| escape(v) }.join(', ')})"
          else
            ActiveRecord::Base.connection.quote(value)
          end
        end

      end

    end

  end

end
