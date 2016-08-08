module Noventius

  class Validation

    attr_reader :name, :rules, :messages

    def initialize(name, rules = {}, messages = {})
      @name = name.to_sym
      @rules = rules
      @messages = messages
    end

    def to_js
      {
        rules: {
          "#{name}" => rules
        },
        messages: {
          "#{name}" => messages
        }
      }
    end

    def deep_dup
      Marshal.load(Marshal.dump(self))
    end

  end

end
