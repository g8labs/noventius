class AReport < Nuntius::Report

  filter :dasda, :text, value: 'Holaa', options: { class: 'hola' }, icon: 'flash'
  filter :juan, :date, icon: 'flash'
  filter :juana, :datetime, icon: 'calendar'
  filter :qwqwee, :number, options: { max: 1 }
  filter :qwe, :select, option_tags: [%w(Hola Chau), 'Chau'], options: { include_blank: true }
  filter :d, :select, option_tags: :ids, options: { include_blank: true }

  validate :dasda, rules: { required: true }
  validate :juan, rules: { required: true, date: true }
  validate :juana, rules: { required: true, datetime: true }

  def ids
    [[:a, :b, :c], :a]
  end

  def columns
    {
      'Date' => {
        rowspan: 2
      },
      'Offer_1' => {
        colspan: 3,
        rowspan: 1,
        children: {
          'Event_1' => {},
          'Event_2' => {},
          'Event_3' => {}
        }
      },
      'Offer_2' => {
        colspan: 3,
        rowspan: 1,
        children: {
          'Event_1' => {},
          'Event_2' => {},
          'Event_3' => {}
        }
      }
    }
  end

  def rows
    rand(1..10).times.map { |n| 7.times.map { "val_#{n+1}" } }
  end

  def sql
    ''
  end

end
