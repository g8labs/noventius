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
    let(:post_processor) do
      Nuntius::PostProcessors::DateRanges.new(created_at_column_index, step, start_time, end_time, time_zone)
    end

    let(:report) do
      Class.new(Nuntius::Report) do
        include Nuntius::Extension::DateQuery

        filter :group_by, :select, option_tags: :date_extract_options

        def sql
          created_at_for_select = if group_by == 'hour'
                                    "strftime('%H', created_at)"
                                  else
                                    'created_at'
                                  end

          User.select("id, name, role_id, #{created_at_for_select}").to_sql
        end
      end.new(group_by: step.to_s)
    end

    before do
      User.create!(created_at: DateTime.new(2017, 02, 17, 3).in_time_zone(time_zone))
      User.create!(created_at: DateTime.new(2017, 04, 04, 11).in_time_zone(time_zone))
    end

    context 'when the step is day' do

      let(:step)        { :day }
      let(:start_time)  { DateTime.new(2017, 02, 15, 3).utc }
      let(:end_time)    { DateTime.new(2017, 04, 04, 11).utc }

      it 'adds empty rows to complete the days' do
        expect(post_processor.process(report, report.rows).count).to eq(49)
      end

    end

    context 'when the step is month' do

      let(:step)        { :month }
      let(:start_time)  { DateTime.new(2017, 02, 15, 3).utc }
      let(:end_time)    { DateTime.new(2017, 04, 04, 11).utc }

      it 'adds empty rows to complete the months' do
        expect(post_processor.process(report, report.rows).count).to eq(3)
      end

    end

    context 'when the step is hour' do

      let(:step)        { :hour }
      let(:start_time)  { DateTime.new(2017, 04, 03, 3).utc }
      let(:end_time)    { DateTime.new(2017, 04, 04, 11).utc }

      it 'adds empty rows to complete the hours' do
        expect(post_processor.process(report, report.rows).count).to eq(24)
      end

    end

    context 'when the step is day of week' do

      let(:step)        { :dow }
      let(:start_time)  { DateTime.new(2017, 04, 02, 3).utc }
      let(:end_time)    { DateTime.new(2017, 04, 04, 11).utc }

      it 'adds empty rows to complete the days of the week' do
        expect(post_processor.process(report, report.rows).count).to eq(7)
      end

    end

    context 'when the step is months of year' do

      let(:step)        { :moy }
      let(:start_time)  { DateTime.new(2017, 02, 15, 3).utc }
      let(:end_time)    { DateTime.new(2017, 04, 04, 11).utc }

      it 'adds empty rows to complete the months of the year' do
        expect(post_processor.process(report, report.rows).count).to eq(12)
      end

    end

  end

end
