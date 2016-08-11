require 'rails_helper'

RSpec.describe Noventius::PostProcessors::DateRanges do

  describe '.new' do

    it 'raises an error when an invalid step is provided' do
      expect {
        Noventius::PostProcessors::DateRanges.new(:column, :invalid)
      }.to raise_error(ArgumentError)
    end

  end

  describe '#process' do

    let(:created_at_column_index) { 3 }
    let(:time_zone)               { 'America/Montevideo' }
    let(:post_processor) do
      Noventius::PostProcessors::DateRanges.new(created_at_column_index, step, time_zone)
    end

    let(:report) do
      Class.new(Noventius::Report) do
        include Noventius::Extension::DateQuery

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

      let(:step) { :day }

      it 'adds empty rows to complete the days' do
        expect(post_processor.process(report, report.rows).count).to eq(47)
      end

    end

    context 'when the step is month' do

      let(:step) { :month }

      it 'adds empty rows to complete the months' do
        expect(post_processor.process(report, report.rows).count).to eq(2)
      end

    end

    context 'when the step is hour' do

      let(:step) { :hour }

      it 'adds empty rows to complete the hours' do
        expect(post_processor.process(report, report.rows).count).to eq(24)
      end

    end

    context 'when the step is day of week' do

      let(:step) { :dow }

      it 'adds empty rows to complete the days of the week' do
        expect(post_processor.process(report, report.rows).count).to eq(7)
      end

    end

    context 'when the step is months of year' do

      let(:step) { :moy }

      it 'adds empty rows to complete the months of the year' do
        expect(post_processor.process(report, report.rows).count).to eq(12)
      end

    end

  end

end
