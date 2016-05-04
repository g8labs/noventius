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

        REGEX = /:\w+/
        VARIABLE_REGEX = /(?::)(\w+)/

        def interpolate(text)
          return unless text

          text.scan(REGEX).flatten.each do |var|
            var_name = var.match(VARIABLE_REGEX)[1]
            text.gsub!(var, send(var_name.to_sym).to_s)
          end

          text
        end

      end

    end

  end

end
