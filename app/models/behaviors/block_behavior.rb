module BlockBehavior

  MAX_EVENTS_PER_REQUEST=Rails.env.production? ? 30 : 1000000 unless defined? MAX_EVENTS_PER_REQUEST
  def check_max_events
    $EVENTS_COUNT=($EVENTS_COUNT || 0) + 1
    raise "Too many events" if $EVENTS_COUNT>MAX_EVENTS_PER_REQUEST
  end

  def self.reset_events_count
    $EVENTS_COUNT=0
  end

  # TODO: ПРОТЕСТИРОВАТЬ ПРИ ОТСУТСТВИИ КОМАНДЫ/ПОЛЬЗОВАТЕЛЯ для общих случаев, например общее присвоение переменной/проверка
  # @return Array descendant events of the game for user(his team and common), optionally by the var name
  def descendant_events_of options
    de=[]
    de+=de_scoped(options).for_one(options[:user]) if options[:user]
    de+=de_scoped(options).for_team(options[:user].team) if options[:user] && options[:user].team_id
    de+=de_scoped(options).for_all
  end

  # helper method for scoping descendant_events
  def de_scoped options
    descendant_events.block_type(options[:type]).visit_count(options[:visit_count]).var(options[:variable])
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
    if task
      !task.visit_count && task.load_rooms(options)
      events.or({scope: :for_one, user_id: options[:user].id, visit_count: task.visit_count}, {scope: :for_team, team_id: options[:user].team_id, visit_count: task.visit_count}, {scope: :for_all, visit_count: task.visit_count}).any?
    else
      events.or({scope: :for_one, user_id: options[:user].id}, {scope: :for_team, team_id: options[:user].team_id}, {scope: :for_all}).any? #moped doesn't understand <model>
    end
  end

  # @return [Boolean] if there are any events, related to this block
  def is_hit_by_any?
    events.any?
  end

  # method is called when hit and hot, or when forced
  # @return [Array] all events, arisen
  def fire options={}
    check_max_events
    options=prepare_options options
    return personal_fire(options) if personal && options[:scope]!=:for_one # мне это воспринять на свой счет? (вулкан задел жителя)
    event=create_event options
    block_actions options
    [event]+hit_relations(options.merge(
      parent_id: event.id,
      source_id: options[:source_id] || (options[:source]||event).id,
      responsible_user: nil,
      reason: nil,
      input: nil
    ))
  end

  def fire_with_critical_section options={}
    return fire_without_critical_section options if !options[:mutex]
    CriticalSection.synchronize game_id do fire_without_critical_section options end
  end

  alias_method_chain :fire, :critical_section

  # fire personal events for scope users
  def personal_fire options
    scope_users(options).each { |user| fire options.merge(scope: :for_one, user: user, force_scope: true) } ##проблема в том, что, если мы делаем P*, то у нас get_scope возвращается всегда for_all и fire уходит в бесконечную рекурсию
  end

  # prepare options for fire
  def prepare_options options
    options.merge! scope: get_scope(options), game: game, task: task, force_scope: nil, mutex: nil
    options[:user]||=User.find options[:user_id] if options[:user_id]
    options[:team]=options[:user].team if options[:scope]==:for_team
    options.reverse_merge! time: Time.now
  end

  # @returns event created
  def create_event options
    task && !task.visit_count && task.load_rooms(options)
    Event.create options.merge block_id: id, visit_count: task && task.visit_count
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