class Menu
  attr_accessor :items

  def initialize(items = {})
    @items = items
  end

  def add_item(item_name, item_price)
    @items[item_name] = item_price
  end

  def remove_item(item_name)
    @items.delete(item_name)
  end

  def copy
    Menu.new(copy_items)
  end

  private

  def copy_items
    @items.map { |name, price| [name, price] }.to_h
  end
end