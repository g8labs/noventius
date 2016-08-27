module Noventius

  class Engine < ::Rails::Engine

    isolate_namespace Noventius

    config.autoload_paths << root.join('app/helpers/concerns/')

    config.after_initialize do
      Noventius::Report.load_all
    end

    config.generators do |g|
      g.test_framework :rspec
    end

  end

end
