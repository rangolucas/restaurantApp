require 'geokit'

class MakeAnOrder
  def initialize(store_repository)
    @store_repository = store_repository
  end

  # Returns true only if the user is close enough to the store
  def invoke(store_id, table_id, amount_by_item, user_coordinates, takeaway)
    store = @store_repository.fetch_by_id(store_id)
    if store.is_close_to(user_coordinates)
      if store.accepts_order(amount_by_item)
        register_order(store_id, table_id, amount_by_item, takeaway)
        :success
      else
        :invalid_order
      end
    else
      :not_in_store_radius
    end
  end

  private

  def register_order(store_id, table_id, amount_by_item, takeaway)
    @store_repository.update_store(
        store_id,
        -> (saved_store) { saved_store.register_order(table_id, amount_by_item, takeaway) }
      )
  end
end