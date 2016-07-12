require_dependency 'nuntius/application_controller'

module Nuntius

  class ReportsController < ApplicationController

    before_action :ensure_report, only: [:show]

    def index
      reports
    end

    def show
      respond_to do |format|
        format.html
        format.csv { render text: @report.to(:csv) }
      end
    end

    protected

    def ensure_report
      @report = report_class.new(filter_params)
    end

    def report_class
      params.require(:name).constantize
    end

  end

end
