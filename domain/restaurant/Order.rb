class Order
  attr_accessor :to_take_away

  def initialize(user_id, amount_by_item, to_take_away)
    @state = :Pending
    @user_id = user_id
    @amount_by_item = amount_by_item
    @to_take_away = to_take_away
  end

  def mark_as_accepted
    if @state == :Pending
      @state = :Accepted
      true
    else false
    end
  end

  def mark_as_rejected
    if @state == :Pending
      @state = :Rejected
      true
    else false
    end
  end

  def mark_as_ready
    if @state.is_a?(AcceptedState)
      @state.mark_as_ready
    else false
    end
  end
end

class AcceptedState
  attr_accessor :ready_to_serve
  def initialize()
    @ready_to_serve = false
  end

  def mark_as_ready()
    if @ready_to_serve
      false
    else 
      @ready_to_serve = true
      true
    end
  end
end
