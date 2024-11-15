require './domain/restaurant/Menu'

class Store
  attr_accessor :id, :coordinates, :time_table, :contact_info, :menu, :orders

  def initialize(id, coordinates, time_table, contact_info)
    @id = id
    @coordinates = coordinates
    @time_table = time_table
    @contact_info = contact_info
    @menu = Menu.new
    @orders = Hash.new
  end

  def add_item(item_name, itemPrice)
    return @menu.add_item(item_name, itemPrice)
  end

  def remove_item(item_name)
    @menu.removeItem(item_name)
  end

  def get_menu_items
    @menu.items
  end

  def register_order(user_id, amount_by_item)
    order_id = SecureRandom.uuid[0..3]
    @orders[order_id] = Order.new(user_id, amount_by_item)
  end

  def accept_order(order_id)
    @orders[order_id].mark_as_accepted
  end

  def mark_as_ready(order_id)
    @orders[order_id].mark_as_ready
  end

  def delete_order(order_id)
    @orders.delete(order_id)
  end

  def copy
    Store.new(id, coordinates, time_table, contact_info, menu.copy, copy_orders)
  end

  private

  def copy_orders
    @orders.map { |id, order| [id, order.copy] }.to_h
  end
end