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
                                  elsif group_by == 'dow'
                                    "strftime('%w', created_at)"
                                  elsif group_by == 'moy'
                                    "strftime('%m', created_at)"
                                  elsif group_by == 'day'
                                    "strftime('%Y-%m-%d', created_at)"
                                  elsif group_by == 'month'
                                    "strftime('%Y-%m-01', created_at)"
                                  else
                                    'created_at'
                                  end

          User.select("id, name, role_id, #{created_at_for_select}").to_sql
        end
      end.new(group_by: step.to_s)
    end

    context 'when the step is day' do

      let(:step) { :day }

      before do
        User.create!(created_at: DateTime.new(2017, 02, 17).in_time_zone(time_zone))
        User.create!(created_at: DateTime.new(2017, 02, 19).in_time_zone(time_zone))
        User.create!(created_at: DateTime.new(2017, 02, 24).in_time_zone(time_zone))
      end

      it 'adds empty rows to complete the days' do
        expected_result = [[kind_of(Integer), nil, nil, DateTime.new(2017, 02, 17).in_time_zone(time_zone)],
                           [nil, nil, nil, DateTime.new(2017, 02, 18).in_time_zone(time_zone)],
                           [kind_of(Integer), nil, nil, DateTime.new(2017, 02, 19).in_time_zone(time_zone)],
                           [nil, nil, nil, DateTime.new(2017, 02, 20).in_time_zone(time_zone)],
                           [nil, nil, nil, DateTime.new(2017, 02, 21).in_time_zone(time_zone)],
                           [nil, nil, nil, DateTime.new(2017, 02, 22).in_time_zone(time_zone)],
                           [nil, nil, nil, DateTime.new(2017, 02, 23).in_time_zone(time_zone)],
                           [kind_of(Integer), nil, nil, DateTime.new(2017, 02, 24).in_time_zone(time_zone)]]

        expect(post_processor.process(report, report.rows)).to match(expected_result)
      end

    end

    context 'when the step is month' do

      let(:step) { :month }

      before do
        User.create!(created_at: DateTime.new(2017, 02, 17).in_time_zone(time_zone))
        User.create!(created_at: DateTime.new(2017, 05, 04).in_time_zone(time_zone))
      end

      it 'adds empty rows to complete the months' do
        expected_result = [[kind_of(Integer), nil, nil, DateTime.new(2017, 02, 01).in_time_zone(time_zone)],
                           [nil, nil, nil, DateTime.new(2017, 03, 01).in_time_zone(time_zone)],
                           [nil, nil, nil, DateTime.new(2017, 04, 01).in_time_zone(time_zone)],
                           [kind_of(Integer), nil, nil, DateTime.new(2017, 05, 01).in_time_zone(time_zone)]]

        expect(post_processor.process(report, report.rows)).to match(expected_result)
      end

    end

    context 'when the step is hour' do

      let(:step) { :hour }

      before do
        User.create!(created_at: DateTime.new(2017, 02, 17, 3).in_time_zone(time_zone))
        User.create!(created_at: DateTime.new(2017, 02, 17, 8).in_time_zone(time_zone))
      end

      it 'adds empty rows to complete the hours' do
        expected_result = [[nil, nil, nil, 0],
                           [nil, nil, nil, 1],
                           [nil, nil, nil, 2],
                           [kind_of(Integer), nil, nil, 3],
                           [nil, nil, nil, 4],
                           [nil, nil, nil, 5],
                           [nil, nil, nil, 6],
                           [nil, nil, nil, 7],
                           [kind_of(Integer), nil, nil, 8],
                           [nil, nil, nil, 9],
                           [nil, nil, nil, 10],
                           [nil, nil, nil, 11],
                           [nil, nil, nil, 12],
                           [nil, nil, nil, 13],
                           [nil, nil, nil, 14],
                           [nil, nil, nil, 15],
                           [nil, nil, nil, 16],
                           [nil, nil, nil, 17],
                           [nil, nil, nil, 18],
                           [nil, nil, nil, 19],
                           [nil, nil, nil, 20],
                           [nil, nil, nil, 21],
                           [nil, nil, nil, 22],
                           [nil, nil, nil, 23]]

        expect(post_processor.process(report, report.rows)).to match(expected_result)
      end

    end

    context 'when the step is day of week' do

      let(:step) { :dow }

      before do
        User.create!(created_at: DateTime.new(2017, 02, 17, 3).in_time_zone(time_zone))
        User.create!(created_at: DateTime.new(2017, 04, 04, 11).in_time_zone(time_zone))
      end

      it 'adds empty rows to complete the days of the week' do
        expected_result = [[nil, nil, nil, 0],
                           [nil, nil, nil, 1],
                           [kind_of(Integer), nil, nil, 2],
                           [nil, nil, nil, 3],
                           [nil, nil, nil, 4],
                           [kind_of(Integer), nil, nil, 5],
                           [nil, nil, nil, 6]]

        expect(post_processor.process(report, report.rows)).to match(expected_result)
      end

    end

    context 'when the step is months of year' do

      let(:step) { :moy }

      before do
        User.create!(created_at: DateTime.new(2017, 02, 17, 3).in_time_zone(time_zone))
        User.create!(created_at: DateTime.new(2017, 04, 04, 11).in_time_zone(time_zone))
      end

      it 'adds empty rows to complete the months of the year' do
        expected_result = [[nil, nil, nil, 0],
                           [nil, nil, nil, 1],
                           [kind_of(Integer), nil, nil, 2],
                           [nil, nil, nil, 3],
                           [kind_of(Integer), nil, nil, 4],
                           [nil, nil, nil, 5],
                           [nil, nil, nil, 6],
                           [nil, nil, nil, 7],
                           [nil, nil, nil, 8],
                           [nil, nil, nil, 9],
                           [nil, nil, nil, 10],
                           [nil, nil, nil, 11]]

        expect(post_processor.process(report, report.rows)).to match(expected_result)
      end

    end

  end

end
