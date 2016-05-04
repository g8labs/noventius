require_relative 'report/dsl'
require_relative 'report/interpolator'

module Nuntius

  class Report

    include Dsl
    include Interpolator

    def initialize(filter_params = {})
      @filter_params = filter_params
    end

    def self.all
      Dir.glob(File.expand_path('app/reports/*.rb', Rails.root)).map do |file|
        file[%r{app\/reports\/(.*)\.rb}, 1].classify.constantize
      end
    end

    def complex_columns?
      columns.is_a?(::Hash)
    end

    def result
      @result ||= ActiveRecord::Base.connection.exec_query(interpolate(sql))
    end

    # [Array] Simple Column Structure
    # [Hash] Complex Column Structure
    # {
    #   'name' => {
    #     colspan: 1,
    #     rowspan: 2,
    #     children: {}
    #   }
    # }
    def columns # rubocop:disable Rails/Delegate
      result.columns
    end

    def rows # rubocop:disable Rails/Delegate
      result.rows
    end

    def sql
      fail NotImplementedError, "Abstract method #{__method__}"
    end

  end

end
