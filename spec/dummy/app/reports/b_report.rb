class BReport < Nuntius::Report

  column :column_one, :string, label: 'Column 1'
  column :column_two, :string, label: 'Column 2'
  column :column_tree, :string, label: 'Column 3'

  filter :qwe, :select, option_tags: [%w(Hola Chau), 'Chau'], options: { include_blank: true }
  filter :d, :select, option_tags: :ids, options: { include_blank: true }
  filter :c, :check_box
  filter :b, :date

  def ids
    [[:a, :b, :c], 'b']
  end

  def rows
    rand(1..10).times.map { |n| 3.times.map { "val_#{n+1}" } }
  end

  def sql
    ''
  end

end
