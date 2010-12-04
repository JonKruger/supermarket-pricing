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

