require 'rails_helper'

RSpec.describe Noventius::Serializers::Csv do

  subject(:serializer) { Noventius::Serializers::Csv.new(report) }

  let(:report) do
    Class.new(Noventius::Report) do

      column :date,                         :datetime,  label: 'Date', html_options: { class: 'date' }
      column :offer_hit,                    :integer,   label: -> { name.to_s.humanize }
      column :mobile_verification,          :integer,   label: -> { name.to_s.humanize }
      column :mobile_verification_failure,  :integer,   label: -> { name.to_s.humanize }
      column :mobile_subscription,          :integer,   label: -> { name.to_s.humanize }
      column :mobile_subscription_failure,  :integer,   label: -> { name.to_s.humanize }
      column :conversion_rate,              :string,    label: 'Conversion rate'

      def sql
        User.all.to_sql
      end
    end.new
  end

  before { 5.times { |i| User.create(name: i) } }

  describe '#generate' do

    it 'returns a valid csv' do
      expect {
        serializer.generate
      }.to_not raise_error
    end

    describe 'the returned csv' do

      subject(:csv) { CSV.parse(serializer.generate) }

      it 'has the columns labels of the report as its first line' do
        expect(csv[0]).to eq(['Date', 'Offer hit', 'Mobile verification',
                              'Mobile verification failure', 'Mobile subscription',
                              'Mobile subscription failure', 'Conversion rate'])
      end

      it 'has the rows of the report as its tail lines' do
        report.rows.each_with_index do |row, index|
          expect(csv[index + 1]).to eq(row.map(&:to_s))
        end

      end

    end

  end

end
