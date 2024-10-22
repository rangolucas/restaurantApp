class AddItemToMenu
  def initialize(stores)
    @stores = stores
  end

  def invoke(storeId, itemName, itemPrice)
    store = stores[storeId]
    return store.addItem(itemName, itemPrice)
  end
end