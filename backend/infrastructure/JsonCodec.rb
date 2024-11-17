require './infrastructure/controller/dto/MenuItemDto'
require './infrastructure/controller/dto/OrderCreationDto'
require './infrastructure/controller/dto/StoreCreationDto'

class JsonCodec

  def decode_store_creation(request)
    encoded_coordinates = get_mandatory_field(request, "coordinates")
    coordinates = decode_coordinates(encoded_coordinates)
    name = get_mandatory_field(request, "name")
    time_table = get_mandatory_field(request, "timeTable")
    contact_info = get_mandatory_field(request, "contactInfo")
    StoreCreationDto.new(coordinates, name, time_table, contact_info)
  end
  
  def decode_order_creation(request)
    table_id = get_mandatory_field(request, "table_id")
    amount_by_item = get_mandatory_field(request, "amountByItem")
    encoded_coordinates = get_mandatory_field(request, "userCoordinates")
    user_coordinates = decode_coordinates(encoded_coordinates)
    takeaway = get_mandatory_field(request, "takeaway")
    OrderCreationDto.new(table_id, amount_by_item, user_coordinates, takeaway)
  end

  def decode_table_id(request)
    get_mandatory_field(request, "tableId")
  end

  def decode_menu_item(request)
    name = get_mandatory_field(request, "itemName")
    price = get_mandatory_field(request, "price")
    MenuItemDto.new(name, price)
  end

  def decode_user_tables(request)
    begin
      request == nil ? Hash.new : JSON.parse(request)
    rescue JSON::ParserError
      raise JsonFormatError, "Invalid user tables JSON"
    end
  end

  def encode_order(order)
    encode_order_to_object(order).to_json
  end

  def encode_orders(orders)
    orders.map { |order| encode_order_to_object(order) }.to_json
  end

  def encode_stores(stores)
    stores.map { |s| encode_store(s) }.to_json
  end

  def encode_store_id(id)
    {
      "id": id
    }.to_json
  end
  
  def encode_menu(menu)
    menu.items.map(&:encode_item).to_json
  end

  def encode_order_result(result)
    case result
    when :success
      nil
    when :invalid_order
      {
        "error": "INVALID_ORDER"
      }.to_json
    when :not_in_store_radius
      {
        "error": "NOT_IN_STORE_RADIUS"
      }.to_json
    else
      raise "Unknown order result: '#{result}'"
    end
  end

  def encode_user_tables(user_tables)
    if user_tables == nil
      nil
    else
      user_tables.to_json
    end
  end

  private

  def decode_coordinates(coordinates)
    if coordinates.is_a?(Array) && coordinates.size == 2
      (lat, lon) = coordinates
      Coordinates.new(lat, lon)
    else
      raise JsonFormatError, "Coordinates should be an array of size 2"
    end
  end

  def get_mandatory_field(request, field)
    field_value = request[field]
    if field_value == nil
      raise JsonFormatError, "Missing JSON field '#{field}'"
    else
      field_value
    end
  end

  def encode_order_state(state)
    case state
    when :Pending
      "PENDING"
    when :Accepted
      "ACCEPTED"
    when :Rejected
      "REJECTED"
    when :Ready
      "READY"
    else
      raise "Unknown order state: '#{state}'"
    end
  end

  def encode_order_to_object(order)
    {
      "state": encode_order_state(order.state),
      "table_id": order.table_id,
      "amountByItem": order.amount_by_item,
      "toTakeAway": order.to_take_away
    }
  end

  def encode_item((name, price))
    {
      "itemName": name,
      "price": price
    }
  end

  def encode_store(store)
    {
      "id": store.id,
      "name": store.name,
      "contact": store.contact_info,
      "coordinates": encode_coordinates(store.coordinates)
    }
  end

  def encode_coordinates(coordinates)
    [coordinates.lat, coordinates.lon]
  end
end

class JsonFormatError < StandardError
end
