module Nuntius

  class ApplicationController < ActionController::Base

    protect_from_forgery with: :exception

    helper_method :reports

    def reports
      @reports ||= Nuntius::Loader.report_classes.map(&:new)
    end

  end

end
