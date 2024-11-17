class GetStores
  def initialize(store_repository)
    @store_repository = store_repository
  end

  def invoke
    @store_repository.fetch_all
  end
end