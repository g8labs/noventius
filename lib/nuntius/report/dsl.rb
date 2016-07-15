require_relative 'dsl/filters'
require_relative 'dsl/columns'
require_relative 'dsl/nested'
require_relative 'dsl/validations'

module Nuntius

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
        include Validations::ClassMethods

      end

      module InstanceMethods

        include Filters::InstanceMethods
        include Columns::InstanceMethods
        include Nested::InstanceMethods
        include Validations::InstanceMethods

      end

    end

  end

end
