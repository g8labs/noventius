module Noventius

  module FilterParams

    SCOPE_KEY = :q

    def self.included(base)
      base.helper_method :filter_params
    end

    def filter_params
      var_name = "@#{SCOPE_KEY}"

      if instance_variable_defined?(var_name)
        instance_variable_get(var_name)
      else
        instance_variable_set(var_name, params.fetch(SCOPE_KEY, {}))
      end
    end

  end

end
