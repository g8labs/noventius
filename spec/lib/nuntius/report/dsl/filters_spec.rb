require 'rails_helper'

RSpec.describe Nuntius::Report::Dsl::Filters do

  let(:dummy_class) { Class.new { include Nuntius::Report::Dsl::Filters } }

  subject { dummy_class }

  it { should respond_to :filters }
  it { should respond_to :filter }

  describe '#filters' do

    subject { dummy_class.filters }

    context 'when there are no filters' do
      it { should be_empty }
    end

    context 'when there are filters' do

      let(:filter_1) { FactoryGirl.create(:filter, dirty_args: { priority: 1 }) }
      let(:filter_2) { FactoryGirl.create(:filter) }

      before {
        dummy_class.filter filter_1.name, filter_1.type, filter_1.args.merge(filter_1.options)
        dummy_class.filter filter_2.name, filter_2.type, filter_2.args.merge(filter_2.options)
      }

      it 'should have 2 items' do
        expect(subject.count).to eq(2)
      end

      it 'should have filter_2 first' do
        expect(subject.first.name).to eq(filter_2.name)
      end

      it 'should have filter_1 second' do
        expect(subject.second.name).to eq(filter_1.name)
      end

    end

  end

  describe '#filter' do

    let(:filter) { FactoryGirl.create(:filter) }

    subject { dummy_class.filter filter.name, filter.type, filter.args.merge(filter.options) }

    it 'should add a new filter' do
      expect { subject }.to change(dummy_class.filters, :count).by(1)
    end

    it 'should call #define_filter_accessors' do
      expect(dummy_class).to receive(:define_filter_accessors).with(filter.name, filter.type)
      subject
    end

  end

  describe '#define_filter_accessors' do

    let(:filter) { FactoryGirl.create(:filter) }
    subject { dummy_class.send(:define_filter_accessors, filter.name, filter.type) }

    it 'should add a filter getter to instances' do
      subject
      expect(dummy_class.new).to respond_to(filter.name)
    end

    it 'should add a filter setter to instances' do
      subject
      expect(dummy_class.new).to respond_to("#{filter.name}=")
    end

  end

end
