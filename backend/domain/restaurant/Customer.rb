class Customer
  attr_reader :tables
  
  def initialize(tables)
    @tables = tables
  end

  def table_in_store(store_id)
    @tables[store_id]
  end

  def acquire_table(store_id)
    @tables[store_id] = SecureRandom.uuid
  end
end