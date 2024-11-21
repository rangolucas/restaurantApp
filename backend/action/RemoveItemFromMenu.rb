class RemoveItemFromMenu
  def initialize(store_repository)
    @store_repository = store_repository
  end

  def invoke(store_id, item_id)
    @store_repository.update_store_with_id(
      store_id,
      -> (store) { store.remove_item(item_id) }
    )
  end
end