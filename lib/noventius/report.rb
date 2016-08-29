require_relative 'report/dsl'
require_relative 'report/interpolator'
require_relative 'serializers/csv'

module Noventius

  class Report

    include Dsl
    include Interpolator

    class << self

      attr_reader :tab_title

      def title(title)
        @tab_title = title
      end

      def hidden(hidden)
        @hidden_flag = hidden
      end

      def visible?
        @hidden_flag.nil? || !@hidden_flag
      end

      def load_all
        Dir.glob(File.expand_path("#{Noventius.reports_path}/**/*.rb", Rails.root)).each do |file|
          require_dependency file
        end
      end

      def all
        load_all unless Rails.application.config.eager_load

        Noventius::Report.descendants
      end

      def visibles
        all.select(&:visible?)
      end

    end

    def initialize(filter_params = {})
      @filter_params = filter_params
    end

    def result
      @result ||= ActiveRecord::Base.connection.exec_query(interpolate(sql))
    end

    def columns
      columns = super

      columns = result.columns.map { |column| Column.new(column, :string) } unless columns.any?

      columns
    end

    def rows # rubocop:disable Rails/Delegate
      result.rows
    end

    def processed_rows
      post_processors.inject(rows) do |rows, (post_processor, options)|
        execute = options.fetch(:if, true)
        execute = instance_exec(&execute) if execute.is_a?(Proc)
        execute = public_send(execute) if execute.is_a?(Symbol)

        return rows unless execute

        if post_processor.is_a?(Proc)
          instance_exec(rows, &post_processor)
        elsif post_processor.is_a?(Symbol)
          public_send(post_processor, rows)
        else
          post_processor.process(self, rows)
        end
      end
    end

    def to(format)
      case format
      when :csv
        Serializers::Csv.new(self).generate
      else
        fail NotImplementedError, "No serializer found for: #{format}"
      end
    end

    def sql
      fail NotImplementedError, "Abstract method #{__method__}"
    end

  end

end
