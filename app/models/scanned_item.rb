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


