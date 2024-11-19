class AddItemToMenu
  def initialize(store_repository)
    @store_repository = store_repository
  end

  def invoke(store_id, item_name, item_price)
    store = @store_repository.fetch_by_id(store_id)
    if store.has_item_in_menu?(item_name)
      false
    else
      @store_repository.update_store(
        store_id,
        -> (store) { store.add_item(item_name, item_price) }
      )
      true
    end
  end
end