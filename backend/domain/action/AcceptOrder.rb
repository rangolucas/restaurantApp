class AcceptOrder
  def initialize(stores)
    @stores = stores
  end

  # Returns true only if the order was in pending state
  def invoke(store_id, order_id)
    store = @stores[store_id]
    store.accept_order(order_id)
  end
end