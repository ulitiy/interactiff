class Variable
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String, default: ""
  field :display_name, type: String, default: ""
  field :member_scope, type: String, default: "for_one" # for_one, for_team, for_all
  # field :block_scope, type: Symbol, default: :in_game
  field :display_type, type: Symbol, default: :string #string, status_bar, bool, bool_html, html ##integer, float, ?
  field :default, default: 0

  belongs_to :game, class_name: "Game", index: true
  has_many :events
  # has_many :setters, class_name: "Setter", inverse_of: :variable
  has_and_belongs_to_many :checkers, class_name: "Checker", inverse_of: :variables, index: true

  index({game: 1, name: 1}, {unique: true})

  validates_uniqueness_of :name, scope: :game

  # @return value of variable for current context
  def value options
    event=game.descendant_events_of(user: options[:user], variable: self).sort_by { |e| [e.time, e.id] }.last
    event ? event.var_value : default
  end

end
