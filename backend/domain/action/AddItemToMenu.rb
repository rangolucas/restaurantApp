class AddItemToMenu
  def initialize(store_repository)
    @store_repository = store_repository
  end

  def invoke(store_id, item_name, item_price)
    @store_repository.update_store(
      store_id,
      -> (store) { store.add_item(item_name, item_price) }
    )
  end
end