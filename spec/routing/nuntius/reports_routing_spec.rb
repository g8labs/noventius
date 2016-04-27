require 'rails_helper'

describe Nuntius::ReportsController, type: :routing do

  routes { Nuntius::Engine.routes }

  describe 'routing #index' do

    it 'should routes to reports#index' do
      expect(get: '/reports').to route_to(controller: 'nuntius/reports', action: 'index')
    end

  end

  describe 'routing #show' do

    let(:report_name) { 'report_1' }

    it 'should route to reports#show' do
      expect(get: "/reports/#{report_name}").to route_to(controller: 'nuntius/reports',
                                                         action: 'show',
                                                         name: report_name)
    end

  end

end
