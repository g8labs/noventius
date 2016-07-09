class AReport < Nuntius::Report

  column :date, :datetime,  label: 'Date', html_options: { rowspan: 2 }
  columns_group :offer_1, [column(:event_1, :string, label: 'Event_1'),
                           column(:event_2, :string, label: 'Event_2'),
                           column(:event_3, :string, label: 'Event_3')],
                label: 'Offer_1', html_options: { colspan: 3, rowspan: 1, }
  columns_group :offer_1, [column(:event_1, :string, label: 'Event_1'),
                           column(:event_2, :string, label: 'Event_2'),
                           column(:event_3, :string, label: 'Event_3')], label: 'Offer_1',
                html_options: { colspan: 3, rowspan: 1, }

  filter :flash_with_options, :text, value: 'hi', options: { class: 'css-class' }, icon: 'flash'
  filter :juan, :date, icon: 'flash'
  filter :juana, :datetime, icon: 'calendar'
  filter :qwqwee, :number, options: { max: 1 }
  filter :qwe, :select, option_tags: [%w(Hola Chau), 'Chau'], options: { include_blank: true }
  filter :d, :select, option_tags: :ids, options: { include_blank: true }

  validate :flash_with_options, rules: { required: true }
  validate :juan, rules: { required: true, date: true }
  validate :juana, rules: { required: true, datetime: true }

  def ids
    [[:a, :b, :c], :a]
  end

  def rows
    rand(1..10).times.map { |n| 7.times.map { "val_#{n+1}" } }
  end

  def sql
    ''
  end

end
