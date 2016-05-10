module Nuntius

  module FormsHelper

    def compile_filters(filters)
      filters.each_with_object({}) { |filter, memo| memo.merge!(scope_keys(filter.to_js)) }
    end

    def compile_validations(validations)
      validations.each_with_object(rules: {}, messages: {}) do |validation, memo|
        memo[:rules].merge!(scope_keys(validation.to_js[:rules]))
        memo[:messages].merge!(scope_keys(validation.to_js[:messages]))
      end
    end

  end

end
