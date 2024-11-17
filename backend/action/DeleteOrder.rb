class DeleteOrder
  def initialize(store_repository)
    @store_repository = store_repository
  end

  def invoke(store_id, order_id)
    @store_repository.update_store(
      store_id,
      -> (store) { store.delete_order(order_id) }
    )
  end
end