module CanCan::Ability
  def get_match action,subject,*extra_args
    relevant_rules_for_match(action, subject).detect do |rule|
      rule.matches_conditions?(action, subject, extra_args)
    end
  end
end

class Ability
  include CanCan::Ability
  #TODO: CHECK & TEST EVERY CONTROLLER ACTION

  def initialize(user)
    cannot :manage, :all
    cannot :read, :all
    user||=Guest.new

    unless user.is_a? Guest
      can [:join,:create,:index], Game
      can :play, Game
    end
    can :play, Game, guest_access: true
    can :show, Game, example: true

    #later - better
    user.engine_roles.each { |role| apply_role role }

    #independent of current role
    #доступ внутрь игры для овнера домена (плюс дублирует game descendants чуть медленнее). Нужно для примеров.
    can :show, Block do |block|
      block.game.present? and
      can?(:show, block.game)
    end
    #independent of current role
    can :show, Relation do |rel|
      can?(:show, rel.game) ||
      can?(:show, rel.from) &&
      can?(:show, rel.to)
    end

    # can :manage, Block do |block|
    #   block.game.present? and
    #   can?(:manage, block.game)
    # end
    can :manage, Relation do |rel|
      can?(:manage, rel.game) ||
      can?(:manage, rel.from) &&
      can?(:manage, rel.to)
    end

  end

  def get_resource_access role
    case role.access
        when :manage_roles then :manage
        when :manage then :manage
        when :read then :read
    end
  end

  def apply_role role
    #ГОЛАКТЕКО ОПАСНОСТЕ!!! Если делаешь can :manage, block то после can :manage, Block для КЛАССА становится истиной!!! Но при этом наоборот работает норм.
    return if role.access==:none
    access=get_resource_access role

    #root
    if role.block.nil?
      can access, Block #т.е. это норм, стопудов
      can :manage, Role if role.access==:manage_roles
      return
    end

    #owner
    if role.access==:manage_roles
      can :manage, Role, block_id: role.block_id
      #independent of current role
      can :manage, Role do |r|
        #может админить роль, если может админить роль предка
        can? :manage, Role.new(block_id: r.block.parent_id) if r.block.parent_id #если не new, а просто доппараметром, то не срабатывает!!! Специфика FactoryGirl
      end
    end

    #block itself
    can access, Block, _id: role.block_id
    #game descendants
    can access, Block, game_id: role.block_id
    #task descendants
    can access, Block, task_id: role.block_id
    #children
    can access, Block, parent_id: role.block_id
  end

end

