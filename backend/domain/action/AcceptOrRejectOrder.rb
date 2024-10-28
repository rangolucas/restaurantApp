class AcceptOrRejectOrder
  def initialize(stores)
    @stores = stores
  end

  # Returns true only if the order was in pending state
  def invoke(store_id, order_id, accepted)
    store = @stores[store_id]
    if accepted
      store.accept_order(order_id)
    else
      store.reject_order(order_id)
    end
  end
end