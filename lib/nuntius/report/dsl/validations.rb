module Nuntius

  class Report

    module Dsl

      module Validations

        def self.included(base)
          base.extend ClassMethods
          base.send :include, InstanceMethods
        end

        module ClassMethods

          def validations
            @validations ||= []
          end

          def validate(name, rules: {}, messages: {})
            validations << {
              name: name.to_sym,
              rules: rules,
              messages: messages
            }
          end

        end

        module InstanceMethods

          def validations
            self.class.validations.deep_dup
          end

        end

      end

    end

  end

end
