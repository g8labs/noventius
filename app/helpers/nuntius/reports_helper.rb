module Nuntius

  module ReportsHelper

    # ColumnNameNodes are found in odd(2n+1) levels of the ComplexColumnTree, so the number of rows in
    # thead has is half the depth of the ComplexColumnTree. (depth/2)
    def number_of_rows_in_cct(cct)
      cct.depth / 2
    end

    # We get all the ColumnNameNodes of the ComplexColumnTree for a given row
    def cells_for_cct_row(cct, n)
      cct.nth_level_children(2 * n + 1)
    end

  end

end
