require './domain/restaurant/Menu'

class Store
  attr_accessor :id, :coordinates, :timeTable, :contactInfo, :menu

  def initialize(id, coordinates, timeTable, contactInfo)
    @id = id
    @coordinates = coordinates
    @timeTable = timeTable
    @contactInfo = contactInfo
    @menu = Menu.new
    @orders = []
  end

  def addItem(itemName, itemPrice)
    return @menu.addItem(itemName, itemPrice)
  end

  def removeItem(itemName)
    @menu.removeItem(itemName)
  end

  def registerOrder(userId, amountByItem)
    @orders.push(Order.new(userId, amountByItem))
  end

  def acceptOrder(orderId)
    @orders[orderId].markAsAccepted
  end

  def rejectOrder(orderId)
    @orders[orderId].markAsRejected
  end

  def markAsReady(orderId)
    @orders[orderId].markAsReady
  end
end