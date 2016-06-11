require_relative 'report/dsl'
require_relative 'report/interpolator'

module Nuntius

  class Report

    include Dsl
    include Interpolator

    class << self

      attr_reader :_title, :_description

      def title(title)
        @_title = title
      end

      def description(description)
        @_description = description
      end

    end

    def initialize(filter_params = {})
      @filter_params = filter_params
    end

    def description
      self.class._description
    end

    def title
      self.class._title
    end

    def name
      self.class.name
    end

    def created_result?(result)
      return false if result.nil?

      result.report.class == self.class
    end

    def execute
      sql_query = interpolate(sql)
      sql_result = ActiveRecord::Base.connection.exec_query(sql_query)

      Result.new(
        sql_result: sql_result,
        report: self
      )
    end

    def sql
      fail NotImplementedError, "Abstract method #{__method__}"
    end

  end

end
