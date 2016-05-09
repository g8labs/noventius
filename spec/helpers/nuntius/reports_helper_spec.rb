require 'rails_helper'

RSpec.describe Nuntius::ReportsHelper, type: :helper do

  include ComplexColumnsExamples

  let(:cct) { complex_columns_1 }

  describe '#number_of_rows_in_cct' do

    subject { helper.number_of_rows_in_cct(cct) }

    it { should eq(2) }

  end

  describe '#cells_for_cct_row' do

    let(:rows_in_cct) { helper.number_of_rows_in_cct(cct) }
    let(:n) { Array(0...rows_in_cct).sample }

    subject { helper.cells_for_cct_row(cct, n) }

    it { should match_array(send("complex_columns_1_level_#{2 * n + 1}")) }

  end

end
