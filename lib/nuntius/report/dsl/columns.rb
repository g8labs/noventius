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

          def columns_names
            @columns_names ||= []
          end

          def column(name, type, options = {})
            validate_name_not_taken!(name)

            Column.new(name, type, options).tap do |column|
              columns_names << column.name
              columns << column
            end
          end

          def columns_group(name, children, options = {})
            validate_name_not_taken!(name)

            ColumnsGroup.new(name, children, options).tap do |columns_group|
              columns_names << columns_group.name
              children.map { |child| columns.delete(child) }

              columns << columns_group
            end
          end

          def dynamic_columns(method_name)
            columns << -> { send(method_name) }
          end

          private

          def validate_name_not_taken!(name)
            fail "Column name: #{name} is taken" if columns_names.include?(name.to_sym)
          end

        end

        module InstanceMethods

          def columns
            return @columns if @columns

            build_columns

            @columns
          end

          def columns_without_groups
            return @columns_without_groups if @columns_without_groups

            build_columns

            @columns_without_groups
          end

          def columns_names
            @columns_names ||= self.class.columns_names.dup
          end

          def column(name, type, options = {})
            validate_name_not_taken!(name)

            Column.new(name, type, options).tap do |column|
              columns_names << column.name
            end
          end

          def column_group(name, children, options = {})
            validate_name_not_taken!(name)

            ColumnsGroup.new(name, children, options).tap do |columns_group|
              columns_names << columns_group.name
            end
          end

          def column_index(name)
            columns_without_groups.find_index { |column| column.name == name }
          end

          private

          def validate_name_not_taken!(name)
            fail "Column name: #{name} is taken" if columns_names.include?(name.to_sym)
          end

          def build_columns
            @columns = self.class.columns.map do |column|
              column = instance_exec(&column) if column.is_a?(Proc)

              column
            end.flatten

            @columns_without_groups = build_columns_without_groups(@columns)
          end

          def build_columns_without_groups(columns)
            columns.map do |column|
              if column.is_a?(Nuntius::Column)
                column
              else
                build_columns_without_groups(column.columns)
              end
            end.flatten
          end

        end

      end

    end

  end

end
