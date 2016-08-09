require 'rails_helper'

RSpec.describe Noventius::Extension::DateQuery, type: :extension do

  let(:dummy_class) { Class.new { include Noventius::Extension::DateQuery } }

  describe '.date_extract' do

    subject { dummy_class.new.date_extract(component: component, column: column) }

    let(:column) { 'created_at' }

    context 'when component is month' do

      let(:component) { 'month' }

      it 'should return the correct SQL function call' do
        expect(subject).to eq(
          "DATE_TRUNC('month', created_at::timestamptz AT TIME ZONE 'America/Montevideo')"
        )
      end

    end

    context 'when component is day' do

      let(:component) { 'day' }

      it 'should return the correct SQL function call' do
        expect(subject).to eq(
          "DATE_TRUNC('day', created_at::timestamptz AT TIME ZONE 'America/Montevideo')"
        )
      end

    end

    context 'when component is dow' do

      let(:component) { 'dow' }

      it 'should return the correct SQL function call' do
        expect(subject).to eq(
          "EXTRACT(DOW from created_at::timestamptz AT TIME ZONE 'America/Montevideo')::integer"
        )
      end

    end

    context 'when component is hour' do

      let(:component) { 'hour' }

      it 'should return the correct SQL function call' do
        expect(subject).to eq(
          "EXTRACT(HOUR from created_at::timestamptz AT TIME ZONE 'America/Montevideo')::integer"
        )
      end

    end

    context 'when component is moy' do

      let(:component) { 'moy' }

      it 'should return the correct SQL function call' do
        expect(subject).to eq(
          "EXTRACT(MONTH from created_at::timestamptz AT TIME ZONE 'America/Montevideo')::integer"
        )
      end

    end

  end

end
