module Nuntius

  class ApplicationController < ActionController::Base

    helper_method :reports

    protect_from_forgery with: :exception

    def reports
      @reports ||= Report.all
    end

  end

end
