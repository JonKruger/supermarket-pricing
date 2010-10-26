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

class Item
  attr_reader :name, :price, :available_discounts
  def initialize(name, price, available_discounts = [])
    @name = name
    @price = price
    @available_discounts = available_discounts
  end
end

class ScannedItem 
  attr_reader :item, :applied_discount

  def initialize(item)
    @item = item
  end

  def apply_discounts(all_scanned_items)
    item.available_discounts.each do |discount|
      if discount.apply_discount?(item, all_scanned_items)
        @applied_discount = discount
        return
      end
    end
  end

  def price
    @applied_discount ? @applied_discount.price : item.price
  end
end

class MultipleItemDiscount
  attr_reader :quantity, :price_for_quantity

  def initialize(quantity, price_for_quantity)
    @quantity = quantity
    @price_for_quantity = price_for_quantity
  end

  def apply_discount?(scanned_item, all_scanned_items)
    false
  end
end

class CheckOut
  ITEMS = { "A" => Item.new("A", 50, [MultipleItemDiscount.new(3, 130)]),
            "B" => Item.new("B", 30, [MultipleItemDiscount.new(2, 45)]),
            "C" => Item.new("C", 20),
            "D" => Item.new("D", 15) }

  def initialize
    @scanned_items = []
  end

  def scan(item_name)
    item = ScannedItem.new(ITEMS[item_name])
    @scanned_items << item
    item.apply_discounts(@scanned_items)
  end

  def total
    total_price = 0
    @scanned_items.each { |item| total_price += item.price }
    total_price
  end
end
