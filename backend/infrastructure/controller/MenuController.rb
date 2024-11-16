class MenuController
  
  def initialize(get_menu_action, add_item_action)
    @get_menu_action = get_menu_action
    @add_item_action = add_item_action
  end

  def get_menu(store_id)
    menu = @get_menu_action.invoke(store_id)
    encode_menu_to_json(menu)
  end

  def add_item(store_id, request)
    @add_item_action.invoke(store_id, request["itemName"], request["price"])
  end

  private

  def encode_menu_to_json(menu)
      menu.items.map(&:encode_item_to_json).to_json
  end

  def encode_item_to_json((name, price))
    {
      "itemName": name,
      "price": price
    }
  end
end
