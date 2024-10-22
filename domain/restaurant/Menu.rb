class Menu
  attr_accessor :items

  def initialize()
    @items = {}
  end

  def addItem(itemName, itemPrice)
    @items[itemName] = itemPrice
  end

  def removeItem(itemName)
    @items.delete(itemName)
  end
end