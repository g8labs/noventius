class BReport < Nuntius::Report

  filter :qwe, :select, options_tags: [%w(Hola Chau), 'Chau'], options: { include_blank: true }
  filter :d, :select, options_tags: :ids, options: { include_blank: true, require: true }

  def ids
    [:a, :b, :c]
  end

  def columns
    ['Column 1', 'Column 2', 'Column 3']
  end

  def rows
    rand(1..10).times.map { |n| 3.times.map { "val_#{n+1}" } }
  end

  def sql
    ''
  end

end
