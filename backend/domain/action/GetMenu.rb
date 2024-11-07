class GetMenu
  def initialize(stores)
    @stores = stores
  end

  def invoke(store_id)
    store = @stores[store_id.to_i] # No sé por qué es necesario el cast, si se puede sacar buenísimo
    store.get_menu_items
  end
end
