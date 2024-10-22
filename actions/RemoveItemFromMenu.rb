class RemoveItemFromMenu
  def initialize(stores)
    @stores = stores
  end

  def invoke(storeId, itemName)
    store = stores[storeId]
    return store.removeItem(itemName)
  end
end