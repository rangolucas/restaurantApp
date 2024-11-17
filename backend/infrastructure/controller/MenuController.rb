class MenuController
  
  def initialize(get_menu_action, add_item_action, codec)
    @get_menu_action = get_menu_action
    @add_item_action = add_item_action
    @codec = codec
  end

  def get_menu(store_id)
    menu = @get_menu_action.invoke(store_id)
    @codec.encode_menu(menu)
  end

  def add_item(store_id, request)
    menu_item = @codec.decode_menu_item(request)
    @add_item_action.invoke(store_id, menu_item.name, menu_item.price)
  end
end
