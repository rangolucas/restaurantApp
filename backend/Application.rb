require './controller/StoreController'
require './controller/OrderController'
require './domain/action/CreateStore'
require './domain/action/GetStores'
require './domain/action/MakeAnOrder'

require 'json'
require 'sinatra'
require 'sinatra/cors'

set :allow_origin, '*'
set :bind, '0.0.0.0'

stores = []

create_store = CreateStore.new(stores)
get_stores = GetStores.new(stores)
make_an_order = MakeAnOrder.new(stores)

order_controller = OrderController.new(make_an_order)
store_controller = StoreController.new(create_store, get_stores)

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
