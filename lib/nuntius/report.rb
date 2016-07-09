require_relative 'report/dsl'
require_relative 'report/interpolator'

module Nuntius

  class Report

    include Dsl
    include Interpolator

    class << self

      attr_reader :tab_title

      def title(title)
        @tab_title = title
      end

    end

    def initialize(filter_params = {})
      @filter_params = filter_params
    end

    def self.all
      Dir.glob(File.expand_path('app/reports/*.rb', Rails.root)).map do |file|
        file[%r{app\/reports\/(.*)\.rb}, 1].classify.constantize
      end
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

    def sql
      fail NotImplementedError, "Abstract method #{__method__}"
    end

  end

end
