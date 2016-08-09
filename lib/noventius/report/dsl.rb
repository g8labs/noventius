require_relative 'dsl/filters'
require_relative 'dsl/columns'
require_relative 'dsl/nested'
require_relative 'dsl/post_processors'
require_relative 'dsl/validations'

module Noventius

  class Report

    module Dsl

      def self.included(base)
        base.extend ClassMethods
        base.send :include, InstanceMethods
      end

      module ClassMethods

        include Filters::ClassMethods
        include Columns::ClassMethods
        include Nested::ClassMethods
        include PostProcessors::ClassMethods
        include Validations::ClassMethods

      end

      module InstanceMethods

        include Filters::InstanceMethods
        include Columns::InstanceMethods
        include Nested::InstanceMethods
        include PostProcessors::InstanceMethods
        include Validations::InstanceMethods

      end

    end

  end

end
