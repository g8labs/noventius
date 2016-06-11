require_dependency 'nuntius/application_controller'

module Nuntius

  class ReportsController < ApplicationController

    include FilterParams

    def index
    end

    def show
      @report = report_class.new
    end

    def execute
      @report = report_class.new(filter_params)
      @result = @report.execute

      render :show
    end

    protected

    def report_class
      params.require(:name).constantize
    end

  end

end
