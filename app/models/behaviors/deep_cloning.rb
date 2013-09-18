module DeepCloning # unless Game
  def deep_clone options={}
    @mapping=options[:mapping] || {}
    c=copy
    c.cloning=true
    c.updated_at=c.created_at=Time.now
    c.parent_id=options[:parent_id]
    c.game=c.parent.parent_game
    c.task=c.parent.parent_task
    before_clone_save
    c.save! validate: false

    children.each do |child|
      child.deep_clone(parent_id: c.id, mapping: @mapping)
    end

    c.cloning=false
    c
  end

  # clone on demand
  def copy m=nil
    @mapping||=m
    @copy||=@mapping[id] || self.clone
    @mapping[id]=@copy
  end

  def before_clone_save
  end

end
