require 'spec_helper'

describe "Given that I have not checked anything out" do
  before :each do
    @check_out = CheckOut.new
  end

  [["A", 50], ["B", 30], ["C", 20], ["D", 15]].each do |item, unit_price|
  describe "When I check out an invididual item" do
    it "The total price should be the unit price of that item" do
      @check_out.scan(item)
      @check_out.total.should == unit_price
    end
  end
  end

  [["AAA", 130],
    ["BB", 45],
    ["CCC", 60],
    ["DDD", 45],
    ["BBB", 75],
    ["BABBAA", 205],
    ["", 0]].each do |items, expected_total_price|
    describe "When I check out multiple items" do
      it "The total price should be the expected total price of those items" do
        individual_items = items.split(//)
        individual_items.each { |item| @check_out.scan(item) }
        @check_out.total.should == expected_total_price
      end
    end
  end

end

class RoundingTester
  include Rounding
end

[[1, 1],
  [1.225, 1.23],
  [1.2251, 1.23],
  [1.2249, 1.22],
  [1.22, 1.22]].each do |amount, rounded_amount|
  describe "When rounding an amount of money to the nearest penny" do
    it "Should round the amount using midpoint rounding" do
      RoundingTester.new.round_money(amount).should == rounded_amount
    end
  end
end
