class OrderCreationDto
  attr_reader :user_id, :amount_by_item, :coordinates

  def initialize(user_id, amount_by_item, coordinates)
    @user_id = user_id
    @amount_by_item = amount_by_item
    @coordinates = coordinates
  end
end