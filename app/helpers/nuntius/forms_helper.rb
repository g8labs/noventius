module Nuntius

  module FormsHelper

    SCOPE_KEY = Nuntius::FilterParams::SCOPE_KEY

    def scope_params(params)
      Hash[*params.flat_map do |k, v|
        [scope_name(k), v]
      end]
    end

    def scope_name(name)
      "#{SCOPE_KEY}[#{name}]"
    end

    def compile_validations(validations)
      aux = { messages: {}, rules: {} }
      validations.each do |v|
        scoped_name = scope_name(v[:name])
        aux[:rules][scoped_name] = v[:rules]
        aux[:messages][scoped_name] = v[:messages]
      end
      aux
    end

    def compile_filters(filters)
      aux = {}
      filters.each do |f|
        scoped_name = scope_name(f[:name])
        aux[scoped_name] = {
          type: f[:type],
          options: f[:options]
        }
      end
      aux
    end

  end

end
