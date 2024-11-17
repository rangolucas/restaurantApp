require './infrastructure/controller/dto/OrderCreationDto'

class JsonCodec
  
  def decode_order_creation(request)
    user_id = get_mandatory_field(request, "userId")
    amount_by_item = get_mandatory_field(request, "amountByItem")
    encoded_coordinates = get_mandatory_field(request, "userCoordinates")
    user_coordinates = decode_coordinates(encoded_coordinates)
    OrderCreationDto.new(user_id, amount_by_item, user_coordinates)
  end

  def decode_order_id(request)
    get_mandatory_field(request, "orderId")
  end

  def encode_order(order)
    {
      "state": encode_order_state(order.state),
      "userId": order.user_id,
      "amountByItem": order.amount_by_item.to_json,
      "toTakeAway": order.to_take_away
    }.to_json
  end

  private

  def decode_coordinates(coordinates)
    if coordinates.size == 2
      (lat, lon) = coordinates
      Coordinates.new(lat, lon)
    else
      raise JsonFormatError
    end
  end

  def get_mandatory_field(request, field)
    field_value = request[field]
    if field_value == nil
      raise JsonFormatError, "JSON field '#{field}' should not be null"
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
end

class JsonFormatError < StandardError
end
