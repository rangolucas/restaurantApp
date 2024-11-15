class GetMenu
  def initialize(store_repository)
    @store_repository = store_repository
  end

  def invoke(store_id)
    store = @store_repository.fetch_by_id(store_id.to_i) # No sé por qué es necesario el cast, si se puede sacar buenísimo
    store.get_menu_items
  end
end
