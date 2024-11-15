class RemoveItemFromMenu
  def initialize(store_repository)
    @store_repository = store_repository
  end

  def invoke(store_id, item_name)
    @store_repository.update_store(
      store_id,
      -> (store) { store.remove_item(item_name) }
    )
  end
end