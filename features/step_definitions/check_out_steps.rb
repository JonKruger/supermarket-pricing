Given /^that I have not checked anything out$/ do
  @check_out = CheckOut.new 
end

When /^I check out item "([^"]*)"$/ do |item|
  @check_out.scan(item)
end

Then /^the total price should be the (\d+) of that item$/ do |price|
  @check_out.total.should == price.to_f
end

class CheckOut
  def initialize
    @total = 0
  end

  def scan(item)
    @total += price(item)
  end

  def total
    @total
  end

  private

  def price(item)
    case item
    when "A" then 50
    when "B" then 30
    when "C" then 20
    when "D" then 15
    else raise "Unknown item"
    end
  end
end
