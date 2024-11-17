require 'json'

require './domain/Coordinates'

class StoreController
  def initialize(create_store_action, get_stores_action, acquire_table_action, codec)
    @create_store_action = create_store_action
    @get_stores_action = get_stores_action
    @acquire_table_action = acquire_table_action
    @codec = codec
  end

  def create_store(encoded_request)
    decoded_request = @codec.decode_store_creation(encoded_request)
    store_id = @create_store_action.invoke(decoded_request.coordinates, decoded_request.name, decoded_request.time_table, decoded_request.contact_info)
    @codec.encode_store_id(store_id)
  end

  def get_stores
    all_stores = @get_stores_action.invoke
    @codec.encode_stores(all_stores)
  end

  def acquire_table(store_id, encoded_request)
    user_tables = @codec.decode_user_tables(encoded_request)
    updated_user_tables = @acquire_table_action.invoke(store_id, user_tables)
    @codec.encode_user_tables(updated_user_tables)
  end
end