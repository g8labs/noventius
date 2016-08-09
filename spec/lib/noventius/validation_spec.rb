require 'rails_helper'

RSpec.describe Noventius::Validation do

  let(:options) { {} }
  let(:validation) { FactoryGirl.create(:validation, options) }

  subject { validation }

  it { should respond_to :name }
  it { should respond_to :rules }
  it { should respond_to :messages }

  describe '#to_js' do

    subject { validation.to_js }

    let(:name) { 'validation_name' }
    let(:rules) { { required: true } }
    let(:messages) { { required: 'Required error message.' } }

    before { options.merge!(name: name, rules: rules, messages: messages) }

    it 'should return the following structure' do
      expect(subject).to eq(rules: {
                              "#{name}" => rules
                            },
                            messages: {
                              "#{name}" => messages
                            })
    end

  end

  describe '#deep_dup' do

    subject { validation.deep_dup }

    it "should be a #{described_class}" do
      expect(subject).to be_a(described_class)
    end

    it 'should have a different object_id' do
      expect(subject.object_id).to_not eq(validation.object_id)
    end

  end

end
