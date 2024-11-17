class AcquireTable
  
  def invoke(store_id, user_tables)
    if user_tables.has_key?(store_id)
      nil
    else
      user_tables[store_id] = SecureRandom.uuid
      user_tables
    end
  end
end