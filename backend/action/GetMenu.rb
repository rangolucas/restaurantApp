class GetMenu
  def initialize(store_repository)
    @store_repository = store_repository
  end

  def invoke(store_id)
    store = @store_repository.fetch_by_id(store_id)
    store.menu
  end
end
