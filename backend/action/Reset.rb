class Reset
  
  def initialize(store_repository)
    @store_repository = store_repository
  end

  def invoke
    @store_repository.clean
  end
end