require 'geokit'

class MakeAnOrder
  def initialize(store_repository)
    @store_repository = store_repository
  end

  def invoke(store_id, customer, amount_by_item, user_coordinates, takeaway)
    store = @store_repository.fetch_by_id(store_id)
    table_id = customer.table_in_store(store_id)
    order_validation = store.validate_order(table_id, user_coordinates, amount_by_item)
    if order_validation == :success
      register_order(store_id, table_id, amount_by_item, takeaway)
    end
    order_validation
  end

  private

  def register_order(store_id, table_id, amount_by_item, takeaway)
    @store_repository.update_store_with_id(
        store_id,
        -> (saved_store) { saved_store.register_order(table_id, amount_by_item, takeaway) }
      )
  end
end