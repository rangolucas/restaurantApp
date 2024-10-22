class MarkOrderAsReady
  def initialize(stores)
    @stores = stores
  end

  # Returns true only if the order was in accepted state
  def invoke(store_id, order_id)
    store = @stores[store_id]
    store.mark_as_ready(order_id)
  end
end