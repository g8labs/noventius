require 'rails_helper'

RSpec.describe Noventius::FilterWrappers do

  describe '#date_filter_tag' do
    it 'returns the expected html input' do
      expect(date_filter_tag(:date_input)).to have_tag(:input, with: { name: :date_input,
                                                                       type: :text,
                                                                       'data-type' => :date })
    end
  end

  describe '#datetime_filter_tag' do
    it 'returns the expected html input' do
      expect(datetime_filter_tag(:datetime_input)).to have_tag(:input, with: { name: :datetime_input,
                                                                               type: :text,
                                                                               'data-type' => :datetime })
    end
  end

  describe '#email_filter_tag' do
    it 'returns the expected html input' do
      expect(email_filter_tag(:email_input)).to have_tag(:input, with: { name: :email_input,
                                                                         type: :email })
    end
  end

end
