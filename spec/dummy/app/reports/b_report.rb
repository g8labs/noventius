class BReport < Nuntius::Report

  title 'B Report'
  description <<-DESC
    This is a very simple report. It is based on the B table.
    At the moment this report has 4 filters.

    Responsable: Steve <steve@company.com>
  DESC


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
    <<-SQL
      SELECT *
      FROM users;
    SQL
  end

end
