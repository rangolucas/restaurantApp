class GetOrder
  def initialize(store_repository)
    @store_repository = store_repository
  end

  def invoke(store_id, order_id)
    store = @store_repository.fetch_by_id(store_id)
    store.get_order_with_id(order_id)
  end
end