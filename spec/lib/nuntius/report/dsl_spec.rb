require 'rails_helper'

RSpec.describe Nuntius::Report::Dsl do

  describe 'ClassMethods' do

    subject { Nuntius::Report::Dsl::ClassMethods.included_modules }

    it { should include(Nuntius::Report::Dsl::Filters::ClassMethods) }
    it { should include(Nuntius::Report::Dsl::Validations::ClassMethods) }

  end

  describe 'InstanceMethods' do

    subject { Nuntius::Report::Dsl::InstanceMethods.included_modules }

    it { should include(Nuntius::Report::Dsl::Filters::InstanceMethods) }
    it { should include(Nuntius::Report::Dsl::Validations::InstanceMethods) }

  end

end
