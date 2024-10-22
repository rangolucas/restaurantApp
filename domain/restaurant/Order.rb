class Order
  attr_accessor :toTakeAway

  def initialize(userId, amountByItem, toTakeAway)
    @state = :Pending
    @userId = userId
    @amountByItem = amountByItem
    @toTakeAway = toTakeAway
  end

  def markAsAccepted
    if @state == :Pending
      @state = :Accepted
      true
    else false
    end
  end

  def markAsRejected
    if @state == :Pending
      @state = :Rejected
      true
    else false
    end
  end

  def markAsReady
    if @state.is_a?(AcceptedState)
      @state.markAsReady
    else false
    end
  end
end

class AcceptedState
  attr_accessor :readyToServe
  def initialize()
    @readyToServe = false
  end

  def markAsReady()
    if @readyToServe
      false
    else 
      @readyToServe = true
      true
    end
  end
end
