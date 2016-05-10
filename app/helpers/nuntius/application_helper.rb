module Nuntius

  module ApplicationHelper

    SCOPE_KEY = Nuntius::FilterParams::SCOPE_KEY

    def scope_name(name)
      "#{SCOPE_KEY}[#{name}]"
    end

    def scope_keys(params)
      Hash[*params.flat_map do |k, v|
        [scope_name(k), v]
      end]
    end

  end

end
