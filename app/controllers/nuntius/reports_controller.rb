require_dependency 'nuntius/application_controller'

module Nuntius

  class ReportsController < ApplicationController

    before_action :set_reports
    before_action :ensure_report, only: [:show]

    def index
    end

    def show
    end

    protected

    def filter_params
      @q ||= params.fetch(:q, {})
    end

    def set_reports
      @reports ||= Report.all
    end

    def ensure_report
      @report = report_class.new(filter_params)
    end

    def report_class
      params.require(:name).constantize
    end

  end

end
