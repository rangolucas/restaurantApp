require 'json'

class OrderController
  def initialize(make_order_action, accept_order_action, mark_order_as_ready_action, delete_order_action, get_order_action)
    @make_order_action = make_order_action
    @get_order_action = get_order_action
    @accept_order_action = accept_order_action
    @make_order_as_ready_action = mark_order_as_ready_action
    @delete_order_action = delete_order_action
  end

  def make_order(store_id, request)
    user_id = request["userId"]
    amount_by_item = request["amountByItem"]
    user_coordinates = request["userCoordinates"]
    @make_order_action.invoke(store_id, user_id, amount_by_item, user_coordinates)
  end

  def get_order(store_id, order_id)
    order = @get_order_action.invoke(store_id, order_id)
    encode_order(order)
  end

  def accept_order(store_id, request)
    order_id = request["orderId"]
    @accept_order_action.invoke(store_id, order_id)
  end

  def mark_order_as_ready(store_id, request)
    order_id = request["orderId"]
    @mark_order_as_ready_action.invoke(store_id, order_id)
  end

  def delete_order(store_id, request)
    order_id = request["orderId"]
    @delete_order_action.invoke(store_id, order_id)
  end

  private

  def encode_order(order)
    {
      "state": encode_order_state(order.state),
      "userId": order.user_id,
      "amountByItem": order.amount_by_item.to_json,
      "toTakeAway": order.to_take_away
    }.to_json
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