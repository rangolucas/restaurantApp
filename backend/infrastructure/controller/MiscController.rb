class MiscController
  def initialize(reset_action)
    @reset_action = reset_action
  end

  def reset
    @reset_action.invoke
  end
end