module CanCan::Ability
  def get_match action,subject,*extra_args
    relevant_rules_for_match(action, subject).detect do |rule|
      rule.matches_conditions?(action, subject, extra_args)
    end
  end
end

class Ability
  include CanCan::Ability

  def initialize(user)
    cannot :manage, :all
    cannot :read, :all
    user||=User.new
    #later - better
    user.roles.each do |role|
      next if role.access==:none
      access=case role.access
      when :manage_roles then :manage
      when :manage then :manage
      when :read then :read
      end


      #independent of current role
      can access, Relation do |rel|
        can?(access, rel.from) &&
        can?(access, rel.to)
      end

      #root
      if role.block.nil?
        can access, Block
        can :manage, Role if role.access==:manage_roles
        next
      end

      #owner
      if role.access==:manage_roles
        can :manage, Role, block_id: role.block_id
        #independent of current role
        can :manage, Role do |r|
          #может админить роль, если может админить роль предка
          can? :manage, Role.new(block_id: r.block.parent_id) if r.block.parent_id.present? #если не new, а просто доппараметром, то не срабатывает!!! Специфика FactoryGirl
        end
      end

      #block itself
      can access, Block, _id: role.block_id
      #children
      can access, Block, parent_id: role.block_id
      #game descendants
      can access, Block, game_id: role.block_id
      #task descendants
      can access, Block, task_id: role.block_id

      #independent of current role
      can access, Block do |block|
        can?(access, block.task) or
        can?(access, block.game) or
        (
          block.game.present? and
          can?(access, block.game.parent)
        )
      end
    end #each
  end #initialize
end #class
