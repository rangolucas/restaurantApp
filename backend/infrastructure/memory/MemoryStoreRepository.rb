class MemoryStoreRepository
  def initialize
    @stores = {}
    @next_id = 0
  end

  def fetch_by_id(store_id)
    @stores[store_id].copy
  end

  def fetch_all
    @stores.values.map(&:copy)
  end

  def create_store(coordinates, time_table, contact_info)
    new_store = Store.new(@next_id.to_s, coordinates, time_table, contact_info)
    @stores[@next_id] = new_store
    @next_id += 1
    new_store.copy
  end

  def update_store(store)
    if @stores.has_key?(store.id)
      @stores[store.id] = store
    else
      raise_update_error(store.id)
    end
  end

  def update_store(store_id, update_action)
    update_existing_store(
      store_id,
      -> (store) {
        store = fetch_by_id(store.id)
        update_action(store)
        @stores[store.id] = store
      }
    )
  end

  private

  def with_existing_store(store_id, action_on_store)
    if @stores.has_key?(store.id)
      store = fetch_by_id(store.id)
      action_on_store(store)
      @stores[store.id] = store
    else
      raise "Store with id '#{store_id}' not found"
    end
  end
end