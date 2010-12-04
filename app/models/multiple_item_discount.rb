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


