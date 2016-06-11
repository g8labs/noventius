require 'rails_helper'

RSpec.describe Nuntius::Report do

  describe '#initialize' do

    subject { described_class.new(filter_params) }

    let(:filter_params) { { foo: :bar } }

    it 'should assign the correct filter_params' do
      expect(subject.filter_params).to eq(filter_params)
    end

  end

end
