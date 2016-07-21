require 'rails_helper'

RSpec.describe Nuntius::FormsHelper do

  before { helper.extend Nuntius::ApplicationHelper }

  describe '#compile_filters' do

    subject { helper.compile_filters(filters) }

    let(:filters) {
      [
        FactoryGirl.create(:filter, name: :name_1, type: :text,
                                    dirty_args: { options: { foo: :bar }, icon: :value }),
        FactoryGirl.create(:filter, name: :name_2, type: :text, dirty_args: {})
      ]
    }

    let(:compiled_filters) {
      {
        'q[name_1]' => { type: :text, options: { priority: 0, icon: :value } },
        'q[name_2]' => { type: :text, options: { priority: 0 } }
      }
    }

    it { should eq(compiled_filters) }

  end

  describe '#compile_validations' do

    subject { helper.compile_validations(validations) }

    let(:validations) {
      [
        FactoryGirl.create(:validation, name: :name_1, rules: { required: true },
                                        messages: { required: 'Required message.' }),
        FactoryGirl.create(:validation, name: :name_2, rules: {}, messages: {})
      ]
    }

    let(:compiled_validations) {
      {
        rules: {
          'q[name_1]' => { required: true },
          'q[name_2]' => {}
        },
        messages: {
          'q[name_1]' => { required: 'Required message.' },
          'q[name_2]' => {}
        }
      }
    }

    it { should eq(compiled_validations) }

  end

end
