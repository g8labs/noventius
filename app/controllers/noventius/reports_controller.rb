require_dependency 'noventius/application_controller'

module Noventius

  class ReportsController < ApplicationController

    before_action :set_report, only: [:show, :nested]
    before_action :set_nested_report, only: [:nested]

    def index
      reports
    end

    def show
      respond_to do |format|
        format.html
        format.csv { render text: @report.to(:csv) }
      end
    end

    def nested
      respond_to do |format|
        format.html { render layout: false }
      end
    end

    protected

    def set_report
      @report ||= report_class.new(filter_params)
    rescue NameError
      redirect_to reports_path, alert: 'Report not found'
    end

    def set_nested_report
      @nested_report ||= @report.build_nested_report(params[:row])
    end

    def report_class
      params.require(:name).constantize
    end

  end

end
