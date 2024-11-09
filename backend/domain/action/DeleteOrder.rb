class DeleteOrder
  def initialize(stores)
    @stores = stores
  end

  def invoke(store_id, order_id)
    store = @stores[store_id]
    store.delete_order(order_id)
  end
end