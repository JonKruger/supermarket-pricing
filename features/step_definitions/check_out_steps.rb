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


class IndividualPricingStrategy
  def applies?(item, existing_items)
    true
  end

  def scan(item, existing_items)
    @item = item
    existing_items << self
  end

  def price
    case @item
    when "A" then 50
    when "B" then 30
    when "C" then 20
    when "D" then 15
    else raise "Unknown item"
    end
  end
end

class CheckOut
  PRICING_STRATEGIES = [IndividualPricingStrategy]

  def initialize
    @existing_events = []
  end

  def scan(item)
    PRICING_STRATEGIES.each do |strategy_klass|
      strategy = strategy_klass.new
      if strategy.applies?(item, @existing_events)
        strategy.scan(item, @existing_events)
        return
      end
    end
  end

  def total
    total_price = 0
    @existing_events.each { |event| total_price += event.price }
    total_price
  end
end
