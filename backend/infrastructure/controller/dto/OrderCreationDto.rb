class OrderCreationDto
  attr_reader :table_id, :amount_by_item, :coordinates, :takeaway

  def initialize(table_id, amount_by_item, coordinates, takeaway)
    @table_id = table_id
    @amount_by_item = amount_by_item
    @coordinates = coordinates
    @takeaway = takeaway
  end
end