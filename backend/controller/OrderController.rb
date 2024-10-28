require 'json'

class OrderController
  def initialize(make_order_action)
    @make_order_action = make_order_action
  end

  def make_order(store_id, request)
    user_id = request["user_id"]
    amount_by_item = request["amount_by_item"]
    user_coordinates = request["user_coordinates"]
    @make_order_action.invoke(store_id, user_id, amount_by_item, user_coordinates)
  end
end