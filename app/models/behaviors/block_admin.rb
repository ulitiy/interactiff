# Extracted methods for admin part
module BlockAdmin
  extend ActiveSupport::Concern

  module ClassMethods
    # @param [Integer] id id of current page (parent)
    # @return [Array] all blocks necessary for requested page: in game – game path+descendants, all domains or domain children otherwise+I/O
    def master_collection id
      # return Domain.all if id=="0"
      b=Block.find(id)
      # if b.is_a? Domain
      #   c=b.children#.includes([:inputs, :outputs]) #все детишки (можно с ранней подгрузкой внуков)
      #   io=c.reduce([]) { |arr,child| arr+child.children.where(:_type=>{"$in"=>["Input","Output"]})} #все необходимые внуки
      #   return [b]+c+io #я, дети и внуки
      # end
      b=b.parent_game
      b.path+b.descendants
    end
  end

  # Overriden as_json adding type and id fields
  def as_json options={}
    super options.merge(:methods=>[:type,:id,:digest])
  end

  # @return [String] block class name
  def type
    self.class.name
  end

  # @return [Array] all ancestors + self
  def path
    return [self] unless self.parent
    self.parent.path+[self]
  end

  # TODO: make the game link to itself
  # @return [Game] first Game in path (self or ancestor)
  def parent_game
   return self if self.class==Game
   self.game
  end

  # @return [Game] first Task in path (self or ancestor)
  def parent_task
   return self if self.class==Task
   self.task
  end

  # @return [Array] all descendants (children + their descentants)
  def descendants
    children.reduce(children) do |arr,c|
      arr+c.descendants
    end
  end

  # alias direct_descendants descendants #т.к. для экономии времени сделаем прямую ссылку на некоторые типы контейнеров
end
