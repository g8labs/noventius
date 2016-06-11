module Nuntius

  module Loader

    # Get all the report classes defined in rails app/reports folder.
    #
    # @return [Array<Class>] The report classes
    def self.report_classes
      Dir.glob(File.expand_path('app/reports/*.rb', Rails.root)).map do |file|
        file[%r{app\/reports\/(.*)\.rb}, 1].classify.constantize
      end
    end

  end

end
