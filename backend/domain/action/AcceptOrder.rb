class AcceptOrder
  def initialize(store_repository)
    @store_repository = store_repository
  end

  # Returns true only if the order was in pending state
  def invoke(store_id, order_id)
    @store_repository.update_store(
      store_id,
      -> (store) { store.accept_order(order_id) }
    )
  end
end