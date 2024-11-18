class Order
  attr_reader :state, :table_id, :amount_by_item, :to_take_away

  def initialize(table_id, amount_by_item, takeaway)
    @state = :Pending
    @table_id = table_id
    @amount_by_item = amount_by_item
    @takeaway = takeaway
  end

  def is_in_progress
    @state == :Pending || @state == :Accepted
  end

  def mark_as_accepted
    if @state != :Ready
      @state = :Accepted
    end
  end

  def mark_as_ready
    if @state != :Accepted
      raise "Order must be accepted before it can be marked as ready"
    else 
      @state = :Ready
    end
  end

  def copy
    Order.new(@table_id, @amount_by_item, @takeaway)
  end
end
