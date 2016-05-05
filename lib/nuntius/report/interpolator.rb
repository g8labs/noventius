module Nuntius

  class Report

    module Interpolator

      def self.included(base)
        base.extend ClassMethods
        base.send :include, InstanceMethods
      end

      module ClassMethods

      end

      module InstanceMethods

        REGEX = /({\w+})+/
        VARIABLE_REGEX = /(?:{)(\w+)(?:})/

        def interpolate(text)
          return unless text

          text.scan(REGEX).flatten.each do |var|
            var_name = var.match(VARIABLE_REGEX)[1]
            value = send(var_name.to_sym)

            text.gsub!(var, escape(value))
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
