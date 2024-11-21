require './domain/restaurant/Menu'
require './domain/restaurant/Order'

class Store
  attr_reader :id, :coordinates, :name, :address, :time_table, :contact_info, :menu, :orders, :logo

  def initialize(id, coordinates, name, address, time_table, contact_info, logo, next_table_assigned = 1, menu = Menu.new, orders = Hash.new)
    @id = id
    @coordinates = coordinates
    @name = name
    @address = address
    @time_table = time_table
    @contact_info = contact_info
    @logo = logo
    @next_table_assigned = next_table_assigned
    @menu = menu
    @orders = orders
  end

  def add_item(item_name, itemPrice)
    @menu.add_item(item_name, itemPrice)
  end

  def remove_item(item_id)
    @menu.remove_item(item_id)
  end

  def get_orders
    @orders.values
  end

  def has_item_in_menu?(item_name) 
    @menu.has_item?(item_name)
  end

  def validate_order(table_id, user_coordinates, amount_by_item)
    if !self.is_close_to(user_coordinates)
      :not_in_store_radius
    elsif table_id.nil?
      :no_table_assigned
    elsif self.has_order_in_progress(table_id)
      :order_in_progress
    elsif !self.accepts_order(amount_by_item)
      :invalid_order
    else
      :success
    end
  end

  def register_order(table_id, amount_by_item, takeaway)
    @orders[table_id] = Order.new(table_id, amount_by_item, takeaway)
  end

  def get_order_for_table(table_id)
    order = @orders[table_id]
    if order.nil?
      nil
    else
      order.copy
    end
  end

  def assign_table(customer)
    @next_table_assigned.tap {
      @next_table_assigned += 1
    }.to_s
  end

  def accept_order(table_id)
    @orders[table_id].mark_as_accepted
  end

  def reject_order(table_id)
    @orders[table_id].mark_as_rejected
  end

  def mark_as_ready(order_id)
    @orders[order_id].mark_as_ready
  end

  def delete_order(order_id)
    @orders.delete(order_id)
  end

  def is_close_to(coordinates)
    @coordinates.distance_to(coordinates, units: :meters) < 2000
  end

  def accepts_order(amount_by_item)
    @menu.has_all_items?(amount_by_item.keys)
  end

  def copy
    Store.new(@id, @coordinates, @name, @address, @time_table, @contact_info, @logo, @next_table_assigned, @menu.copy, copy_orders)
  end

  private

  def has_order_in_progress(table_id)
    order = get_order_for_table(table_id)
    order != nil && order.is_in_progress
  end

  def copy_orders
    @orders.map { |id, order| [id, order.copy] }.to_h
  end
end
