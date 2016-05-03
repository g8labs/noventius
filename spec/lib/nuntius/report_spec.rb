require 'rails_helper'

RSpec.describe Nuntius::Report do

  it { should respond_to :query_params }

  describe 'ClassMethods' do

    describe '#all' do

      subject { described_class.all }

      it 'should return all reports' do
        expect(subject).to match_array([AReport, BReport])
      end

    end

  end

  describe 'InstanceMethods' do

    describe '#initialize' do

      subject { described_class.new(query_params) }

      let(:query_params) { { foo: :bar } }

      it 'should assign the correct query_params' do
        expect(subject.query_params).to eq(query_params)
      end

    end

    describe '#complex_columns?' do

      subject { described_class.new.complex_columns? }

      before { allow_any_instance_of(described_class).to receive(:columns).and_return(return_value) }

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

    describe '#result' do

      subject { report.result }
      let(:report) { described_class.new }

      let(:sql) { '' }
      let(:ar_connection) { double(:activerecord_connection) }

      before do
        allow(report).to receive(:sql).and_return(sql)
        allow(ActiveRecord::Base).to receive(:connection).and_return(ar_connection)
        allow(ar_connection).to receive(:exec_query).with(sql)
      end

      it 'should execute SQL query' do
        expect(report).to receive(:sql)
        expect(ar_connection).to receive(:exec_query).with(sql)
        subject
      end

    end

  end

  describe '#columns' do

    subject { described_class.new.columns }

    let(:columns) { %w(Col1 Col2 Col3) }
    let(:ar_result) { double(:activerecord_result) }

    before do
      allow_any_instance_of(described_class).to receive(:result).and_return(ar_result)
      allow(ar_result).to receive(:columns).and_return(columns)
    end

    it 'should call columns on result' do
      expect(ar_result).to receive(:columns)
      subject
    end

    it 'should return the correct values' do
      expect(subject).to eq(columns)
    end

  end

  describe '#rows' do

    subject { described_class.new.rows }

    let(:rows) { [%w(Row1 Row1 Row1), %w(Row2 Row2 Row2)] }
    let(:ar_result) { double(:activerecord_result) }

    before do
      allow_any_instance_of(described_class).to receive(:result).and_return(ar_result)
      allow(ar_result).to receive(:rows).and_return(rows)
    end

    it 'should call columns on result' do
      expect(ar_result).to receive(:rows)
      subject
    end

    it 'should return the correct values' do
      expect(subject).to eq(rows)
    end

  end

end
