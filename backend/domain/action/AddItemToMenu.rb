class AddItemToMenu
  def initialize(stores)
    @stores = stores
  end

  def invoke(store_id, item_name, item_price)
    store = stores[store_id]
    return store.add_item(item_name, item_price)
  end
end