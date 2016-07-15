require 'rails_helper'

RSpec.describe Nuntius::AlertsHelper do

  describe '#flash_alert' do

    it 'does not return anything without flashes' do
      allow(helper).to receive(:flash) { {} }

      element = helper.flash_alert

      expect(element).to eql('')
    end

    it 'returns an alert success when a notice' do
      allow(helper).to receive(:flash) { { notice: 'Hello' } }

      element = helper.flash_alert

      expect(element).to have_tag(:div,
                                  text: '×Hello',
                                  with: { class: 'alert fade in alert-success' }) {

                           with_tag(:button,
                                    text: '×',
                                    with: {
                                      class: 'close',
                                      'data-dismiss' => 'alert'
                                    })

                         }
    end

    it 'passes the extra classes to the alert' do
      allow(helper).to receive(:flash) { { notice: 'Hello' } }

      element = helper.flash_alert(class: 'extra-class')

      expect(element).to have_tag(:div,
                                  text: '×Hello',
                                  with: { class: 'alert fade in alert-success extra-class' }) {

                           with_tag(:button,
                                    text: '×',
                                    with: {
                                      class: 'close',
                                      'data-dismiss' => 'alert'
                                    })

                         }
    end

    it 'passes extra attributes to the alert' do
      allow(helper).to receive(:flash) { { notice: 'Hello' } }

      element = helper.flash_alert(class: 'extra-class', 'data-no-transition-cache' => true)

      expect(element).to have_tag(:div,
                                  text: '×Hello',
                                  with: {
                                    class: 'alert fade in alert-success extra-class',
                                    'data-no-transition-cache' => true
                                  }) {

                           with_tag(:button,
                                    text: '×',
                                    with: {
                                      class: 'close',
                                      'data-dismiss' => 'alert'
                                    })
                         }
    end

    it 'escapes javascript if not marked as safe by user' do
      allow(helper).to receive(:flash) { { notice: '<script>alert(1)</script>' } }

      element = helper.flash_alert

      expect(element).to have_tag(:div,
                                  text: '×<script>alert(1)</script>',
                                  with: { class: 'alert fade in alert-success' }) {
                           with_tag(:button,
                                    text: '×',
                                    with: {
                                      class: 'close',
                                      'data-dismiss' => 'alert'
                                    })
                         }
    end

    it 'does not escape a link if marked as safe by user' do
      allow(helper).to receive(:flash) { { notice: "<a href='example.com'>awesome link!</a>".html_safe } }

      element = helper.flash_alert

      expect(element).to have_tag(:div,
                                  text: '×awesome link!',
                                  with: { class: 'alert fade in alert-success' }) {
                           [
                             with_tag(:button,
                                      text: '×',
                                      with: {
                                        class: 'close',
                                        'data-dismiss' => 'alert'
                                      }),
                             with_tag(:a,
                                      text: 'awesome link!')
                           ]
                         }
    end

  end

end
