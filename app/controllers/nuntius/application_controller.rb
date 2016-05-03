module Nuntius

  class ApplicationController < ActionController::Base

    helper_method :reports

    protect_from_forgery with: :exception

  end

end
