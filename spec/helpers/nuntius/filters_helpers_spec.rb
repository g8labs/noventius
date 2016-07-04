require 'rails_helper'

RSpec.describe Nuntius::FiltersHelper, type: :helper do

  before { helper.extend Nuntius::ApplicationHelper }

  it { should be_a(Nuntius::FilterWrappers) }

  Nuntius::Filter::TYPES.each do |filter_type|
    it { should respond_to(:"#{filter_type}_filter_tag") }
  end

  describe '#filter_tag' do

    let(:filter) { FactoryGirl.create(:filter) }
    let(:report) { Class.new }
    let(:options) { {} }

    subject { helper.filter_tag(filter, report, options) }

    before do
      allow(helper).to receive(:merge_filter_options).and_return({})
      allow(helper).to receive(:set_current_filter_value).and_return({})
      allow(helper).to receive(:"#{filter.type}_filter_tag").and_return({})
    end

    it 'should call merge_filter_options' do
      expect(helper).to receive(:merge_filter_options).with(filter, options, anything)
      subject
    end

    it 'should call set_current_filter_value' do
      expect(helper).to receive(:set_current_filter_value).with(filter, report)
      subject
    end

    it 'should call [filter_type]_filter_tag' do
      expect(helper).to receive(:"#{filter.type}_filter_tag")
      subject
    end

  end

  describe '#set_current_filter_value' do

    pending "add some examples to (or delete) #{__FILE__}"

  end

  describe '#compile_select_option_tags' do

    pending "add some examples to (or delete) #{__FILE__}"

  end

  describe '#merge_filter_options' do

    pending "add some examples to (or delete) #{__FILE__}"

  end

end
