class MarkOrderAsReady
  def initialize(store_repository)
    @store_repository = store_repository
  end

  # Returns true only if the order was in accepted state
  def invoke(store_id, order_id)
    @store_repository.update_store(
      store_id,
      -> (store) { store.mark_as_ready(order_id) }
    )
  end
end