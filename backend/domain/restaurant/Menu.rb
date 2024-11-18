class Menu
  attr_accessor :items

  def initialize(items = {})
    @items = items
  end

  def add_item(item_name, item_price)
    @items[SecureRandom.uuid] = [item_name, item_price]
  end

  def remove_item(item_id)
    @items.delete(item_id)
  end

  def has_all_items?(item_ids)
    item_ids.all? { |id|
      @items.keys.include?(id)
    }
  end

  def copy
    Menu.new(copy_items)
  end

  private

  def copy_items
    @items.map { |id, (name, price)| [id, [name, price]] }.to_h
  end
end