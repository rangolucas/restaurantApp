require './domain/restaurant/Menu'
require './domain/restaurant/Order'

class Store
  attr_accessor :id, :coordinates, :name, :time_table, :contact_info, :menu, :orders

  def initialize(id, coordinates, name, time_table, contact_info, menu = Menu.new, orders = Hash.new)
    @id = id
    @coordinates = coordinates
    @name = name
    @time_table = time_table
    @contact_info = contact_info
    @menu = menu
    @orders = orders
  end

  def add_item(item_name, itemPrice)
    @menu.add_item(item_name, itemPrice)
  end

  def remove_item(item_name)
    @menu.removeItem(item_name)
  end

  def get_menu
    @menu
  end

  def register_order(user_id, amount_by_item, takeaway)
    order_id = SecureRandom.uuid[0..3]
    @orders[order_id] = Order.new(user_id, amount_by_item, takeaway)
  end

  def get_order_with_id(order_id)
    @orders[order_id].copy
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

  def is_close_to(coordinates)
    @coordinates.distance_to(coordinates, units: :meters) < 50
  end

  def accepts_order(amount_by_item)
    @menu.has_all_items?(amount_by_item.keys)
  end

  def copy
    Store.new(@id, @coordinates, @name, @time_table, @contact_info, @menu.copy, copy_orders)
  end

  private

  def copy_orders
    @orders.map { |id, order| [id, order.copy] }.to_h
  end
end