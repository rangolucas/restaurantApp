class AcceptOrder
  def initialize(store_repository)
    @store_repository = store_repository
  end

  # Returns true only if the order was in pending state
  def invoke(store_id, table_id)
    @store_repository.update_store(
      store_id,
      -> (store) { store.accept_order(table_id) }
    )
  end
end