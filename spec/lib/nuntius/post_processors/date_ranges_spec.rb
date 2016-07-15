require 'rails_helper'

RSpec.describe Nuntius::PostProcessors::DateRanges do

  describe '.new' do

    it 'raises an error when an invalid step is provided' do
      expect {
        Nuntius::PostProcessors::DateRanges.new(:column, :invalid)
      }.to raise_error(ArgumentError)
    end

  end

  describe '#process' do

    let(:created_at_column_index) { 3 }
    let(:time_zone)               { 'America/Montevideo' }
    let(:post_processor)          do
      Nuntius::PostProcessors::DateRanges.new(created_at_column_index, step, time_zone)
    end

    let(:report) do
      Class.new(Nuntius::Report) do
        def sql
          User.all.to_sql
        end
      end.new
    end

    before do
      User.create!(created_at: DateTime.new(2017, 02, 17).in_time_zone(time_zone))
      User.create!(created_at: DateTime.new(2017, 04, 04).in_time_zone(time_zone))
    end

    context 'when the step is hour' do

      let(:step) { :hour }

      it 'adds empty rows to complete the hours' do
        expect(post_processor.process(report, report.rows).count).to eq(1105)
      end

    end

    context 'when the step is day' do

      let(:step) { :day }

      it 'adds empty rows to complete the days' do
        expect(post_processor.process(report, report.rows).count).to eq(46)
      end

    end

    context 'when the step is month' do

      let(:step) { :month }

      it 'adds empty rows to complete the months' do
        expect(post_processor.process(report, report.rows).count).to eq(2)
      end

    end

  end

end
