require 'rails_helper'

RSpec.describe Nuntius::CoreExtensions::Hash::Traverse do

  include ComplexColumnsExamples

  let(:h) { {} }

  describe '.depth ' do

    subject { h.depth }

    context "when it's empty" do

      it { should eq(1) }

    end

    context 'when it has no levels' do

      before { h.merge!(foo: :bar, alice: :bob) }

      it { should eq(1) }

    end

    context 'when it has 1 nested hash' do

      before { h.merge!(foo: {}) }

      it { should eq(2) }

    end

    context 'when it has 2 nested hash' do

      before { h.merge!(foo: { bar: {} }) }

      it { should eq(3) }

    end

    context 'when it has an array of hashes' do

      before { h.merge!(foo: [{}, {}, {}]) }

      it { should eq(2) }

    end

    context 'when it has an array of hashes with 1 nested hash' do

      before { h.merge!(foo: [{}, { bar: {} }, {}]) }

      it { should eq(3) }

    end

  end

  describe '.nth_level_children' do

    subject { h.nth_level_children(level) }

    context 'when level is 0' do

      let(:level) { 0 }

      it { should be_nil }

    end

    context 'when level > 0' do

      context "when it's empty" do

        let(:level) { 1 }

        it { should be_empty }

        context 'when level > hash depth' do

          let(:level) { rand(2..10) }

          it { should be_empty }

        end

      end

      context 'when it has 3 children in level 1' do

        let(:level) { 1 }

        before { h.merge!(complex_columns_1) }

        it { should eq(complex_columns_1_level_1) }

      end

      context 'when it has 7 children in level 2' do

        let(:level) { 2 }

        before { h.merge!(complex_columns_1) }

        it { should eq(complex_columns_1_level_2) }

      end

      context 'when it has 6 children in level 3' do

        let(:level) { 3 }

        before { h.merge!(complex_columns_1) }

        it { should eq(complex_columns_1_level_3) }

      end

      context 'when it has 6 children in level 3' do

        let(:level) { 4 }

        before { h.merge!(complex_columns_1) }

        it { should eq([]) }

      end

    end

  end

end
