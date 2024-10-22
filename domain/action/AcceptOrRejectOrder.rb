class AcceptOrRejectOrder
  def initialize(stores)
    @stores = stores
  end

  # Returns true only if the order was in pending state
  def invoke(storeId, orderId, accepted)
    store = @stores[storeId]
    if accepted
      store.accept(orderId)
    else
      store.reject(orderId)
    end
  end
end