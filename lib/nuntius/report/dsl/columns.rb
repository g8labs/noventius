module Nuntius

  class Report

    module Dsl

      module Columns

        def self.included(base)
          base.extend ClassMethods
          base.send :include, InstanceMethods
        end

        module ClassMethods

          def columns
            @columns ||= []
          end

          def column(name, type, options = {})
            Column.new(name, type, options).tap do |column|
              columns << column
            end
          end

          def columns_group(name, children, options = {})
            ColumnsGroup.new(name, children, options).tap do |columns_group|
              children.map { |child| columns.delete(child) }

              columns << columns_group
            end
          end

          def dynamic_columns(method_name)
            columns << -> { send(method_name) }
          end

        end

        module InstanceMethods

          def columns
            self.class.columns.deep_dup.map do |column|
              column = instance_exec(&column) if column.is_a?(Proc)

              column
            end.flatten
          end

          def column(name, type, options = {})
            Column.new(name, type, options)
          end

          def column_group(name, children, options = {})
            ColumnsGroup.new(name, children, options)
          end

        end

      end

    end

  end

end
