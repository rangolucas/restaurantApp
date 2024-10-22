class MarkOrderAsReady
  def initialize(stores)
    @stores = stores
  end

  # Returns true only if the order was in accepted state
  def invoke(storeId, orderId)
    store = @stores[storeId]
    store.markAsReady(orderId)
  end
end