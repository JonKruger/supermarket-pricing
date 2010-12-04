class Item
  attr_reader :name, :price, :available_discounts
  def initialize(name, price, available_discounts = [])
    @name = name
    @price = price
    @available_discounts = available_discounts
  end
end


