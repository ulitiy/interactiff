module DeepCloning # unless Game
  def deep_clone options={}
    c=self.clone
    c.cloning=true
    self.copy=c
    c.updated_at=c.created_at=Time.now
    c.parent_id=options[:parent_id]
    c.game=c.parent.parent_game
    c.task=c.parent.parent_task
    c.save validate: false

    children.each do |child|
      child.deep_clone(parent_id: c.id)
    end

    c.cloning=false
    c
  end

  # current_user.engine_roles.create! access: :manage_roles, block: @game
end