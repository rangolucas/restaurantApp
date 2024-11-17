class Order
  attr_reader :user_id, :amount_by_item, :to_take_away

  def initialize(user_id, amount_by_item, takeaway)
    @state = :Pending
    @user_id = user_id
    @amount_by_item = amount_by_item
    @takeaway = takeaway
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
    Order.new(@user_id, @amount_by_item, @takeaway)
  end
end
