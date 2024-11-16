require './infrastructure/controller/StoreController'
require './infrastructure/controller/OrderController'
require './infrastructure/memory/MemoryStoreRepository'
require './domain/action/AcceptOrder'
require './domain/action/CreateStore'
require './domain/action/DeleteOrder'
require './domain/action/GetMenu'
require './domain/action/GetStores'
require './domain/action/MakeAnOrder'
require './domain/action/MarkOrderAsReady'

require 'json'
require 'sinatra'
require 'sinatra/cors'

set :allow_origin, '*'
set :bind, '0.0.0.0'

store_repository = MemoryStoreRepository.new

create_store = CreateStore.new(store_repository)
get_stores = GetStores.new(store_repository)
make_an_order = MakeAnOrder.new(store_repository)
accept_order = AcceptOrder.new(store_repository)
mark_order_as_ready = MarkOrderAsReady.new(store_repository)
delete_order = DeleteOrder.new(store_repository)
get_menu = GetMenu.new(store_repository)

order_controller = OrderController.new(make_an_order, accept_order, mark_order_as_ready, delete_order)
store_controller = StoreController.new(create_store, get_stores, get_menu)

post '/stores/:store_id/orders' do
  store_id = params['store_id']
  json_payload = JSON.parse(request.body.read)
  status :created
  order_controller.createOrder(store_id, json_payload)
end

post '/stores' do
  json_payload = JSON.parse(request.body.read)
  store_controller.create_store(json_payload)
  halt :created
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
  store_controller.get_menu(store_id)
end
