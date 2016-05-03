class AReport < Nuntius::Report

  filter :andres, :text, value: 'Holaa', options: { class: 'hola' }
  filter :juan, :date, options: { disabled: true }
  filter :qwqwee, :number, options: { max: 1 }
  filter :qwe, :select, options_tags: [%w(Hola Chau), 'Chau'], options: { include_blank: true }
  filter :d, :select, options_tags: :ids, options: { include_blank: true, require: true }

  def ids
    [:a, :b, :c]
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
