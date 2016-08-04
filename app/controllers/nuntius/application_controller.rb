module Nuntius

  class ApplicationController < ActionController::Base

    include FilterParams

    helper_method :reports

    protect_from_forgery with: :exception

    def reports
      @reports ||= Report.visibles
    end

  end

end
