require './infrastructure/JsonCodec'
require './infrastructure/controller/MenuController'
require './infrastructure/controller/StoreController'
require './infrastructure/controller/OrderController'
require './infrastructure/memory/MemoryStoreRepository'
require './action/AcceptOrder'
require './action/AcquireTable'
require './action/AddItemToMenu'
require './action/CreateStore'
require './action/DeleteOrder'
require './action/GetMenu'
require './action/GetOrder'
require './action/GetStoreOrders'
require './action/GetStores'
require './action/MakeAnOrder'
require './action/MarkOrderAsReady'

require 'json'
require 'sinatra'
require 'sinatra/cookies'
require 'sinatra/cors'

disable :show_exceptions
set :allow_origin, '*'
set :allow_methods, 'GET,HEAD,POST,PUT,PATCH,DELETE,OPTIONS'
set :allow_headers, 'content-type, authorization, accept'
set :bind, '0.0.0.0'

store_repository = MemoryStoreRepository.new
codec = JsonCodec.new

# Admin actions
create_store = CreateStore.new(store_repository)
get_store_orders = GetStoreOrders.new(store_repository)
accept_order = AcceptOrder.new(store_repository)
mark_order_as_ready = MarkOrderAsReady.new(store_repository)
delete_order = DeleteOrder.new(store_repository)
add_item_to_menu = AddItemToMenu.new(store_repository)

# Customer actions
acquire_table = AcquireTable.new
get_stores = GetStores.new(store_repository)
make_an_order = MakeAnOrder.new(store_repository)
get_order = GetOrder.new(store_repository)
get_menu = GetMenu.new(store_repository)

order_controller = OrderController.new(make_an_order, accept_order, mark_order_as_ready, delete_order, get_order, get_store_orders, codec)
store_controller = StoreController.new(create_store, get_stores, acquire_table, codec)
menu_controller = MenuController.new(get_menu, add_item_to_menu, codec)

error JsonFormatError do
  content_type :json
  status 400
  { error: env['sinatra.error'].message }.to_json
end

post '/stores/:store_id/orders' do
  store_id = params['store_id']
  json_payload = JSON.parse(request.body.read)
  order_result = order_controller.make_order(store_id, json_payload)
  if order_result == nil
    status :created
  else
    content_type :json
    status 400
    order_result
  end
end

get '/stores/:store_id/orders' do
  store_id = params['store_id']
  orders = order_controller.get_store_orders(store_id)
  content_type :json
  status :ok
  orders
end

get '/stores/:store_id/orders/:order_id' do
  store_id = params['store_id']
  order_id = params['order_id']
  content_type :json
  status :ok
  order_controller.get_order(store_id, order_id)
end

post '/stores' do
  json_payload = JSON.parse(request.body.read)
  content_type :json
  status :created
  store_controller.create_store(json_payload)
end

get '/stores' do
  content_type :json
  status :ok
  store_controller.get_stores
end

get '/stores/:store_id/menu' do
  store_id = params['store_id']
  content_type :json
  status :ok
  menu_controller.get_menu(store_id)
end

post '/stores/:store_id/menu' do
  store_id = params['store_id']
  json_payload = JSON.parse(request.body.read)
  content_type :json
  status :created
  menu_controller.add_item(store_id, json_payload)
end

get '/stores/:store_id/table' do
  store_id = params['store_id']
  updated_user_tables = store_controller.acquire_table(store_id, cookies["userTables"])
  if updated_user_tables == nil
    status :bad_request
  else
    cookies["userTables"] = updated_user_tables
  end
end
