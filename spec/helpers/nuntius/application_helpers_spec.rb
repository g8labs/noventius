require 'rails_helper'

RSpec.describe Nuntius::ApplicationHelper do

  describe '#scope_name' do

    subject { helper.scope_name(name) }

    let(:name) { 'name' }

    it { should eq("q[#{name}]") }

  end

  describe '#scope_keys' do

    subject { helper.scope_keys(params) }

    let(:params) { { foo: :bar, alice: :bob } }

    it { should eq('q[foo]' => :bar, 'q[alice]' =>  :bob) }

  end

end
