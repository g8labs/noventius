require 'noventius/engine'
require 'noventius/report'
require 'noventius/filter'
require 'noventius/column'
require 'noventius/columns_group'
require 'noventius/validation'
require 'noventius/date_components'
require 'noventius/extensions/date_query'
require 'noventius/extensions/date_format'
require 'noventius/post_processors/date_ranges'
require 'noventius/assets'

module Noventius

  mattr_accessor :reports_path do
    'app/reports'
  end

end
