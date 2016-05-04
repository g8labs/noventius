require 'rails_helper'

RSpec.describe Nuntius::Report::Interpolator do

  let(:dummy_class) { Struct.new(:ids, :event_name) { include Nuntius::Report::Interpolator } }
  let(:interpolable) { dummy_class.new([1, 2, 3], 'event_1') }

  describe '#interpolate' do

    subject { interpolable.interpolate(text) }

    context 'when interpolation variable does not exist' do

      let(:text) { 'The interpolation variable :unknown does not exist' }

      it 'shodul raise NoMethodError error' do
        expect { subject }.to raise_error(NoMethodError)
      end

    end

    context 'when there is no variable interpolation' do

      let(:text) { 'This text has no interpolation variable' }

      it { should eq(text) }

    end

    context 'when interpolation varibale exists' do

      context 'when there is one variable interpolation' do

        let(:text) { 'SELECT * FROM t1 WHERE id IN :ids' }

        it { should eq('SELECT * FROM t1 WHERE id IN [1, 2, 3]') }

      end

      context 'when there are two or more interpolation variables' do

        let(:text) { 'SELECT * FROM t1 WHERE id IN :ids AND event_name = :event_name' }

        it { should eq('SELECT * FROM t1 WHERE id IN [1, 2, 3] AND event_name = event_1') }

      end

    end

  end

end
