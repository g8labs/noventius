require_relative 'dsl/filters'
require_relative 'dsl/columns'
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
        include Validations::ClassMethods

      end

      module InstanceMethods

        include Filters::InstanceMethods
        include Columns::InstanceMethods
        include Validations::InstanceMethods

      end

    end

  end

end
