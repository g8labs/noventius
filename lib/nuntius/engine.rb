module Nuntius

  class Engine < ::Rails::Engine

    isolate_namespace Nuntius

    config.autoload_paths << root.join('app/presenters')
    config.autoload_paths << root.join('app/helpers/concerns/')

    config.generators do |g|
      g.test_framework :rspec
    end

  end

end
