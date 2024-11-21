require './infrastructure/JsonCodec'
require './infrastructure/controller/MenuController'
require './infrastructure/controller/StoreController'
require './infrastructure/controller/OrderController'
require './infrastructure/memory/MemoryStoreRepository'
require './action/AcceptOrder'
require './action/AddItemToMenu'
require './action/CreateStore'
require './action/DeleteOrder'
require './action/GetMenu'
require './action/GetOrderOrMenu'
require './action/GetStoreOrders'
require './action/GetStores'
require './action/MakeAnOrder'
require './action/MarkOrderAsReady'
require './action/RejectOrder'
require './action/RemoveItemFromMenu'

require 'json'
require 'sinatra'
require 'sinatra/cookies'
require 'sinatra/cors'

disable :show_exceptions
set :allow_origin, '*'
set :allow_methods, 'GET,HEAD,POST,PUT,PATCH,DELETE,OPTIONS'
set :allow_headers, 'content-type, authorization, accept'
set :allow_credentials, true
set :bind, '0.0.0.0'

store_repository = MemoryStoreRepository.new
codec = JsonCodec.new

# Admin actions
create_store = CreateStore.new(store_repository)
get_store_orders = GetStoreOrders.new(store_repository)
accept_order = AcceptOrder.new(store_repository)
reject_order = RejectOrder.new(store_repository)
mark_order_as_ready = MarkOrderAsReady.new(store_repository)
delete_order = DeleteOrder.new(store_repository)
add_item_to_menu = AddItemToMenu.new(store_repository)
remove_item_from_menu = RemoveItemFromMenu.new(store_repository)

# Customer actions
get_stores = GetStores.new(store_repository)
make_an_order = MakeAnOrder.new(store_repository)
get_order = GetOrderOrMenu.new(store_repository)
get_menu = GetMenu.new(store_repository)

order_controller = OrderController.new(make_an_order, accept_order, reject_order ,mark_order_as_ready, delete_order, get_order, get_store_orders, codec)
store_controller = StoreController.new(create_store, get_stores, codec)
menu_controller = MenuController.new(get_menu, add_item_to_menu, remove_item_from_menu, codec)

error JsonFormatError do
  content_type :json
  status :bad_request
  { error: env['sinatra.error'].message }.to_json
end

post '/stores/:store_id/orders' do
  store_id = params['store_id']
  json_payload = JSON.parse(request.body.read)
  customer = cookies["X-VerLaCarta-Customer"]
  order_result = order_controller.make_order(store_id, customer, json_payload)
  if order_result.nil? 
    status :created
  else
    content_type :json
    status :bad_request
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

get '/stores/:store_id/check-in' do
  store_id = params['store_id']
  customer = cookies["X-VerLaCarta-Customer"]
  content_type :json
  status :ok
  (customer, order_or_menu) = order_controller.get_order_or_menu(store_id, customer)
  cookies["X-VerLaCarta-Customer"] = customer
  order_or_menu
end

post '/stores/:store_id/menu' do
  store_id = params['store_id']
  json_payload = JSON.parse(request.body.read)
  content_type :json
  if menu_controller.add_item(store_id, json_payload)
    status :created
  else
    status :bad_request
  end
end

get '/stores/:store_id/menu' do
  store_id = params['store_id']
  content_type :json
  status :created
  menu_controller.get_menu(store_id)
end

delete '/stores/:store_id/menu/:item_id' do
  store_id = params['store_id']
  item_id = params['item_id']
  content_type :json 
  status :ok
  menu_controller.remove_item(store_id, item_id)
end

put '/stores/:store_id/orders/:table_id/accept' do
  store_id = params['store_id']
  table_id = params['table_id']
  content_type :json
  status :ok
  order_controller.accept_order(store_id, table_id)
end

put '/stores/:store_id/orders/:table_id/reject' do
  store_id = params['store_id']
  table_id = params['table_id']
  content_type :json
  status :ok
  order_controller.reject_order(store_id, table_id)
end

put '/stores/:store_id/orders/:table_id/ready' do
  store_id = params['store_id']
  table_id = params['table_id']
  content_type :json
  status :ok
  order_controller.mark_order_as_ready(store_id, table_id)
end

delete 'stores/:store_id/orders/:table_id' do
  store_id = params['store_id']
  table_id = params['table_id']
  content_type :json
  status :ok
  order_controller.delete_order(store_id, table_id)
end