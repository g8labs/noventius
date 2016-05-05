class BReport < Nuntius::Report

  filter :qwe, :select, option_tags: [%w(Hola Chau), 'Chau'], options: { include_blank: true }
  filter :d, :select, option_tags: :ids, options: { include_blank: true }
  filter :c, :check_box
  filter :b, :date

  def ids
    [[:a, :b, :c], 'b']
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
