require 'rails_helper'

RSpec.describe Noventius::Filter do

  let(:options) { {} }
  let(:filter) { FactoryGirl.create(:filter, options) }

  subject { filter }

  it 'should allow the following types' do
    expect(described_class::TYPES).to eq(%i(check_box color date datetime email month number phone
                                            radio_button range search select telephone text_area text url
                                            week))
  end

  it 'should have reserved the following args' do
    expect(described_class::RESERVED_ARGS).to eq(%i(icon priority))
  end

  it { should respond_to :name }
  it { should respond_to :type }
  it { should respond_to :args }
  it { should respond_to :options }

  describe '#initialize' do

    context 'when type is not supported' do

      let(:type) { :unsupported }
      before { options.merge!(type: type) }

      it 'should raise and error' do
        expect { subject }.to raise_error(ArgumentError)
      end
    end

    context 'when type is supported' do

      context 'when it receives dirty_args' do

        let(:clean_args) { { class: 'css-class' } }
        let(:reserved_args) { { priority: 0, icon: :value } }
        let(:dirty_args) { clean_args.merge(reserved_args) }

        before { options.merge!(dirty_args: dirty_args) }

        it 'should split the clean_args correctly' do
          expect(subject.args).to eq(clean_args)
        end

        it 'should split the reserved_args correctly' do
          expect(subject.options).to eq(reserved_args)
        end

      end

    end

  end

  describe '#to_js' do

    subject { filter.to_js }

    let(:name) { 'filter_name' }
    let(:type) { described_class::TYPES.sample }
    let(:clean_args) { { class: 'css-class' } }
    let(:reserved_args) { { priority: 0, icon: :value } }
    let(:dirty_args) { clean_args.merge(reserved_args) }

    before { options.merge!(name: name, type: type, dirty_args: dirty_args) }

    it 'should return the following structure' do
      expect(subject).to eq("#{name}" => {
                              type: type,
                              options: reserved_args
                            })
    end

  end

  describe '#deep_dup' do

    subject { filter.deep_dup }

    it "should be a #{described_class}" do
      expect(subject).to be_a(described_class)
    end

    it 'should have a different object_id' do
      expect(subject.object_id).to_not eq(filter.object_id)
    end

  end

end
