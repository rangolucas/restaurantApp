class GetOrderOrMenu
  def initialize(store_repository)
    @store_repository = store_repository
  end

  def invoke(store_id, customer)
    store = @store_repository.fetch_by_id(store_id)
    table = customer.table_in_store(store_id)
    order_or_menu = if table.nil?
      customer.acquire_table(store)
      store.menu
    else
      store.get_order_for_table(table) || store.menu
    end
    [customer, order_or_menu]
  end
end
