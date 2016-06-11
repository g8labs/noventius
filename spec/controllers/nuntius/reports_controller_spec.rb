require 'rails_helper'

module Nuntius

  RSpec.describe ReportsController, type: :controller do
    routes { Nuntius::Engine.routes }
    render_views

    let(:params) { {} }

    describe '#index' do

      subject { get :index, params }

      it 'should be success' do
        subject
        expect(response).to have_http_status(:success)
      end

      it 'should asign the right reports' do
        subject
        expect(assigns(:reports)).to match_array([AReport, BReport])
      end

    end

    describe '#show' do

      subject { get :show, params }

      context 'when name param is present' do

        before { params.merge!(name: report_name) }

        context 'when report does not exist' do

          let(:report_name) { 'UnexistentReport' }

          it 'should be error' do
            expect { subject }.to raise_error(NameError)
          end

        end

        context 'when reports does exist' do

          let(:report_name) { 'AReport' }

          it 'should be success' do
            subject
            expect(response).to have_http_status(:success)
          end

          it 'should asign the right reports' do
            subject
            expect(assigns(:reports)).to match_array([AReport, BReport])
          end

          it 'should asign the right reports' do
            subject
            expect(assigns(:report)).to be_a(report_name.constantize)
          end

        end

      end

    end

    describe '#execute' do

      subject { get :execute, params }

      context 'when name param is present' do

        before { params.merge!(name: report_name) }

        context 'when report does not exist' do

          let(:report_name) { 'UnexistentReport' }

          it 'should be error' do
            expect { subject }.to raise_error(NameError)
          end

        end

        context 'when reports does exist' do

          let(:report_name) { 'AReport' }

          it 'should be success' do
            subject
            expect(response).to have_http_status(:success)
          end

          it 'should asign the right reports' do
            subject
            expect(assigns(:reports)).to match_array([AReport, BReport])
          end

          it 'should asign the right reports' do
            subject
            expect(assigns(:report)).to be_a(report_name.constantize)
          end

          it 'should asign a result' do
            subject
            expect(assigns(:result)).not_to be_nil
          end

        end

      end

    end

  end

end
