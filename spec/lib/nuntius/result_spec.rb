require 'rails_helper'

RSpec.describe Nuntius::Result do

  let(:report) { Nuntius::Report.new }
  let(:result) { described_class.new(sql_result: active_record_result, report: report) }
  let(:active_record_result) {
    double('ActiveRecord::Result', columns: %w(Col1 Col2 Col3 Col4), rows: [1, 2, 3, 4])
  }

  describe '#complex_columns?' do

    subject { result.complex_columns? }

    let(:report) {
      Class.new(Nuntius::Report) {
        def columns
        end
      }.new
    }

    before { allow_any_instance_of(report.class).to receive(:columns).and_return(return_value) }

    context 'when #columns return an Array' do

      let(:return_value) { [] }

      it 'should return false' do
        expect(subject).to be false
      end

    end

    context 'when #columns return a Hash' do

      let(:return_value) { {} }

      it 'should be true' do
        expect(subject).to be true
      end

    end

  end

  describe '#columns' do

    subject { result.columns }

    context 'when report doesn\'t implement columns method' do

      it 'should call columns on result' do
        expect(active_record_result).to receive(:columns)
        subject
      end

      it 'should return the correct values' do
        expect(subject).to eq(%w(Col1 Col2 Col3 Col4))
      end

    end

  end

  describe '#rows' do

    subject { result.rows }

    it 'should call columns on result' do
      expect(active_record_result).to receive(:rows)
      subject
    end

    it 'should return the correct values' do
      expect(subject).to eq([1, 2, 3, 4])
    end

  end

end
