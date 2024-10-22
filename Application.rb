require './controller/StoreController'
require './controller/OrderController'
require './domain/action/CreateStore'
require './domain/action/GetStores'
require './domain/action/MakeAnOrder'

require 'json'
require 'sinatra'

stores = []

create_store = CreateStore.new(stores)
get_stores = GetStores.new(stores)
make_an_order = MakeAnOrder.new(stores)

order_controller = OrderController.new(make_an_order)
store_controller = StoreController.new(create_store, get_stores)

post '/stores/:store_id/orders' do
  store_id = params['store_id']
  jsonPayload = JSON.parse(request.body.read)
  status :created
  order_controller.createOrder(store_id, jsonPayload)
end

post '/stores' do
  jsonPayload = JSON.parse(request.body.read)
  store_controller.create_store(jsonPayload)
  halt :created
end

get '/stores' do
  content_type :json
  status :ok
  store_controller.get_stores
end
