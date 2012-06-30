class EventHandler
  # Sets user/s, time event handler should work with
  def initialize options
    @users=options[:users]
    @user=options[:user]
    @time=options[:time]||Time.now
  end

  def fire block
    block.fire(time: @time,user: @user)
  end

end