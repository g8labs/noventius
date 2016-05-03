require_dependency 'nuntius/application_controller'

module Nuntius

  class ReportsController < ApplicationController

    before_action :set_reports
    before_action :ensure_report, only: [:show]

    def index
    end

    def show
      @report.execute
    end

    protected

    def query_params
      params.fetch(:q, {})
    end

    def set_reports
      @reports ||= Report.all
    end

    def ensure_report
      @report = report_class.new(query_params)
    end

    def report_class
      params.require(:name).constantize
    end

  end

end
