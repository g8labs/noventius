require 'rails_helper'

RSpec.describe Nuntius::Report::Dsl::Validations do

  let(:dummy_class) { Class.new { include Nuntius::Report::Dsl::Validations } }

  subject { dummy_class }

  it { should respond_to :validations }
  it { should respond_to :validate }

  describe '#validations' do

    subject { dummy_class.validations }

    context 'when there are no validations' do
      it { should be_empty }
    end

    context 'when there are validations' do

      let(:validation) { FactoryGirl.create(:validation) }
      before {
        dummy_class.validate validation.name, rules: validation.rules,
                                              messages: validation.messages
      }

      it 'should have 1 item' do
        expect(subject.count).to eq(1)
      end

    end

  end

  describe '#validate' do

    let(:validation) { FactoryGirl.create(:validation) }

    subject {
      dummy_class.validate validation.name, rules: validation.rules,
                                            messages: validation.messages
    }

    it 'should add a new filter' do
      expect { subject }.to change(dummy_class.validations, :count).by(1)
    end

  end

end
