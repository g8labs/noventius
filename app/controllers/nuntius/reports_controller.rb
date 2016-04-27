require_dependency 'nuntius/application_controller'

module Nuntius

  class ReportsController < ApplicationController

    before_action :ensure_report, only: [:show]

    def index
    end

    def show
    end

    protected

    def report_params
      params
    end

    def ensure_report
    end

  end

end
