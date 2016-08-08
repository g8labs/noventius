require 'rails_helper'

RSpec.describe Noventius::Report::Dsl do

  describe 'ClassMethods' do

    subject { Noventius::Report::Dsl::ClassMethods.included_modules }

    it { should include(Noventius::Report::Dsl::Filters::ClassMethods) }
    it { should include(Noventius::Report::Dsl::Validations::ClassMethods) }

  end

  describe 'InstanceMethods' do

    subject { Noventius::Report::Dsl::InstanceMethods.included_modules }

    it { should include(Noventius::Report::Dsl::Filters::InstanceMethods) }
    it { should include(Noventius::Report::Dsl::Validations::InstanceMethods) }

  end

end
