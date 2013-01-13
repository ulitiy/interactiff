module BlockBehavior

  # ПРОТЕСТИРОВАТЬ ПРИ ОТСУТСТВИИ КОМАНДЫ/ПОЛЬЗОВАТЕЛЯ для общих случаев, например общее присвоение переменной/проверка
  # @return Array descendant events of the game for user(his team and common), optionally by the var name
  def descendant_events_of options
    de=[]
    de+=descendant_events.block_type(options[:type]).for_one(options[:user]).var(options[:variable]) if options[:user]
    de+=descendant_events.block_type(options[:type]).for_team(options[:user].team).var(options[:variable]) if options[:user] && options[:user].team_id
    de+=descendant_events.block_type(options[:type]).for_all.var(options[:variable])
  end

  # returns true, if the block should fire on hit. Is overriden by descendants
  def hot? options #срабатывать ли?
    true
  end

  # method is called when the incoming relation is fired
  def hit options={}
    fire options if hot?(options)
  end

  # @return [Boolean] if there are any events, related to current user and this block
  def is_hit? options
    events.or({scope: :for_one, user_id: options[:user].id}, {scope: :for_team, team_id: options[:user].team_id}, {scope: :for_all}).any? #moped doesn't understand <model>
  end

  # @return [Boolean] if there are any events, related to this block
  def is_hit_by_any?
    events.any?
  end

  # method is called when hit and hot, or when forced
  # @return [Array] all events, arisen
  def fire options={}
    options=prepare_options options
    cs=CriticalSection.new(game_id).lock if options[:mutex]
      return personal_fire(options) if personal && options[:scope]!=:for_one # мне это воспринять на свой счет? (вулкан задел жителя)
      event=create_event options
      block_actions options
      ret=[event]+hit_relations(options.merge(
        parent: event,
        source: options[:source]||event,
        responsible_user: nil,
        reason: nil,
        input: nil
      ))
    cs.unlock if options[:mutex]
    ret
  end

  # fire personal events for scope users
  def personal_fire options
    scope_users(options).each { |user| fire options.merge(scope: :for_one, user: user, force_scope: true) } ##проблема в том, что, если мы делаем P*, то у нас get_scope возвращается всегда for_all и fire уходит в бесконечную рекурсию
  end

  # prepare options for fire
  def prepare_options options
    options.merge! scope: get_scope(options)
    options.except! :force_scope, :game, :task, :mutex
    options.merge! team: options[:user].team if options[:scope]==:for_team
    options.reverse_merge! time: Time.now, game: game
  end

  # @returns event created
  def create_event options
    Event.create options.merge block: self
  end

  # @return [Symbol] scope to fire this and descendant blocks. It should be the max scope available.
  def get_scope options
    return options[:scope] if options[:force_scope]
    h={for_one:1, for_team:2, for_all:3}
    h.invert[ [h[options[:scope]] || 0, h[scope]].max ] #хитро
  end

  # method is called when block is fired (ex. send message)
  def block_actions options ; end

  # @return [Array] all blocks, from which relations go to this block (cause blocks)
  def in_blocks
    ids=in_relations.map &:from_id
    Block.find(*ids).to_a
  end

  # @return [Array] all blocks, to which relations go from this block (effect blocks)
  def out_blocks
    ids=out_relations.map &:to_id
    Block.find(*ids).to_a #to array if nil or one
  end

  alias blocks_to_hit out_blocks

  # @return [Array] all users, events should be created for
  def scope_users options
    case options[:scope]
      when :for_one then [options[:user]]
      when :for_team then options[:user].team.members
      when :for_all then game.members
    end
  end

  # hits all {#blocks_to_hit}.
  def hit_relations options
    blocks_to_hit.map { |block| block.hit(options) }.flatten
  end
end