Given /^that I have not checked anything out$/ do
  @check_out = CheckOut.new 
end

When /^I check out item "([^"]*)"$/ do |item|
  @check_out.scan(item)
end

When /^I check out "([^"]*)"$/ do |items|
  individual_items = items.split(//)
  individual_items.each { |item| @check_out.scan(item) }
end

Then /^the total price should be the (\d+) of those items$/ do |expected_total_price|
  @check_out.total.should == expected_total_price.to_f 
end

Then /^the total price should be the (\d+) of that item$/ do |price|
  @check_out.total.should == price.to_f
end

When /^rounding "([^"]*)" to the nearest penny$/ do |amount|
  @rounded_amount = RoundingTester.new.round_money(amount)
end

Then /^it should round it using midpoint rounding to "([^"]*)"$/ do |amount|
  @rounded_amount.should == amount.to_f
end

class RoundingTester
  include Rounding
end


