require_relative 'dsl/filter'

module Nuntius

  class Report

    module Dsl

      def self.included(base)
        base.extend ClassMethods
        base.send :include, InstanceMethods
      end

      module ClassMethods

        include Filter::ClassMethods

      end

      module InstanceMethods

        include Filter::InstanceMethods

      end

    end

  end

end
