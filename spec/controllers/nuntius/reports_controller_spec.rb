require 'rails_helper'

RSpec.describe Nuntius::ReportsController do
  routes { Nuntius::Engine.routes }
  render_views

  describe '#index' do

    it 'returns a success response' do
      get :index

      expect(response).to be_success
    end

    it 'assigns all the reports to @reports' do
      get :index

      expect(assigns(:reports)).to match_array([AReport, BReport])
    end

  end

  describe '#show' do

    let(:params) { { name: report_name } }

    context 'when the report exists' do

      let(:report_name) { 'AReport' }

      it 'returns a success response' do
        get :show, params

        expect(response).to be_success
      end

      it 'assigns all the reports to @reports' do
        get :show, params

        expect(assigns(:reports)).to match_array([AReport, BReport])
      end

      it 'assigns the expected report to @report' do
        get :show, params

        expect(assigns(:report)).to be_a(AReport)
      end

    end

    context 'when the report does not exist' do

      let(:report_name) { 'NonexistentReport' }

      it 'redirects to reports path' do
        get :show, params

        expect(response).to redirect_to(reports_path)
      end

      it 'sets a flash alert message' do
        get :show, params

        expect(flash[:alert]).to eq('Report not found')
      end

    end

  end

  describe '#nested' do

    let(:params) { { name: report_name } }

    context 'when the report exists' do

      let(:report_name) { 'AReport' }

      it 'returns a success response' do
        get :nested, params

        expect(response).to be_success
      end

      it 'assigns the expected report to @report' do
        get :nested, params

        expect(assigns(:report)).to be_a(AReport)
      end

    end

    context 'when the report does not exist' do

      let(:report_name) { 'NonexistentReport' }

      it 'redirects to reports path' do
        get :nested, params

        expect(response).to redirect_to(reports_path)
      end

      it 'sets a flash alert message' do
        get :nested, params

        expect(flash[:alert]).to eq('Report not found')
      end

    end

  end

end
