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

  def create_store(coordinates, name, time_table, contact_info)
    store_id = @next_id.to_s
    new_store = Store.new(store_id, coordinates, name, time_table, contact_info)
    @stores[store_id] = new_store
    @next_id += 1
    new_store.copy
  end

  def update_store(store_id, update_store_action)
    if @stores.has_key?(store_id)
      store = fetch_by_id(store_id)
      update_store_action.call(store)
      @stores[store.id] = store
      nil
    else
      raise "Store with id '#{store_id}' not found"
    end
  end
end