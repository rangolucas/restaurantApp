class RemoveItemFromMenu
  def initialize(stores)
    @stores = stores
  end

  def invoke(store_id, item_name)
    store = stores[store_id]
    return store.remove_item(item_name)
  end
end