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

Then /^it should round it to "([^"]*)"$/ do |amount|
  @rounded_amount.should == amount.to_f
end

module Rounding
  def round_money(amount)
    (amount.to_f * 100).round.to_f / 100
  end
end

class RoundingTester
  include Rounding
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
  attr_accessor :price

  def initialize(item)
    @item = item
    @price = item.price
  end

  def apply_discounts(all_scanned_items)
    item.available_discounts.each do |discount|
      if discount.apply_discount(self, all_scanned_items)
        @applied_discount = discount
        return
      end
    end
  end

  def item_name
    item.name
  end
end

class MultipleItemDiscount
  include Rounding
  attr_reader :quantity, :price_for_quantity

  def initialize(quantity, price_for_quantity)
    @quantity = quantity
    @price_for_quantity = price_for_quantity
  end

  def apply_discount(scanned_item, all_scanned_items)
    potentially_discounted_items = find_all_scanned_items_of_type_that_do_not_have_multiple_item_discount_applied(scanned_item, all_scanned_items)
    if (potentially_discounted_items.length == @quantity)
      unadjusted_price_of_each_item = round_money(price_for_quantity.to_f / quantity)
      potentially_discounted_items.each { |item| item.price = unadjusted_price_of_each_item }
      adjust_price_of_discounted_items(potentially_discounted_items)
      true
    end
    false
  end

  def find_all_scanned_items_of_type_that_do_not_have_multiple_item_discount_applied(scanned_item, all_scanned_items)
    all_scanned_items.select {|item| scanned_item.item_name == item.item_name && 
                                     (item.applied_discount.nil? || item.applied_discount.class != MultipleItemDiscount) }
  end

  private 

  def adjust_price_of_discounted_items(potentially_discounted_items)
    sum_of_items = 0
    potentially_discounted_items.each { |item| sum_of_items += item.price }
    potentially_discounted_items.last.price += (price_for_quantity - sum_of_items)
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

  def what_do_i_have
    @scanned_items.each do |item|
      puts "Scanned item #{item.item_name} at price #{item.price} with #{item.applied_discount ? 'a discount' : 'no discount'}"
    end
  end

  def total
    total_price = 0
    @scanned_items.each { |item| total_price += item.price }
    total_price
  end
end

