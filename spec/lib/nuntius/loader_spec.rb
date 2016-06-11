require 'rails_helper'

RSpec.describe Nuntius::Loader do

  describe '#report_classes' do

    subject { described_class.report_classes }

    it 'should return all report classes' do
      expect(subject).to match_array([AReport, BReport])
    end

  end

end
