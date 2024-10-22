class Menu
  attr_accessor :items

  def initialize()
    @items = {}
  end

  def add_item(item_name, item_price)
    @items[item_name] = item_price
  end

  def remove_item(item_name)
    @items.delete(item_name)
  end
end