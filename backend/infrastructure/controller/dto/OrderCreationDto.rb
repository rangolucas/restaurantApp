class OrderCreationDto
  attr_reader :user_id, :amount_by_item, :coordinates, :takeaway

  def initialize(user_id, amount_by_item, coordinates, takeaway)
    @user_id = user_id
    @amount_by_item = amount_by_item
    @coordinates = coordinates
    @takeaway = takeaway
  end
end