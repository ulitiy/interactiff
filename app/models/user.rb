class User
  include Mongoid::Document
  include Mongoid::Timestamps

  #refinery
  has_and_belongs_to_many :roles, class_name: "RefineryRole", index: true
  has_many :plugins, :class_name => "UserPlugin", dependent: :destroy

  has_many :engine_roles, class_name: "Role", dependent: :destroy
  has_many :events, dependent: :destroy
  has_and_belongs_to_many :member_of_games, class_name: "Game", inverse_of: "members", index: true
  belongs_to :team, index: true
  field :locale, type: String, default: "ru"
  #TODO: множественное присваивание

  # Include default devise modules. Others available are:
  # :token_authenticatable,
  #  and
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :trackable, :timeoutable, :rememberable, :validatable, :confirmable#, :lockable,

  ## Database authenticatable
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Lockable
  # field :locked_at, :type => Time
  # field :failed_attempts, :type => Integer
  # field :unlock_token, type: String

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  # Confirmable
  field :confirmation_token,   :type => String
  field :confirmed_at,         :type => Time
  field :confirmation_sent_at, :type => Time
  field :unconfirmed_email,    :type => String # Only if using reconfirmable

  embeds_many :accounts

  validates_presence_of :email
  validates_presence_of :encrypted_password

  # @return [Array] games, where the user is an author
  def games
    engine_roles.map { |role| role.block if role.block.is_a?(Game) && role.access.in?([:manage,:manage_roles]) }.compact.sort { |a,b| b.updated_at <=> a.updated_at }
  end

  # refinery

  def plugins=(plugin_names)
    if persisted? # don't add plugins when the user_id is nil.
      UserPlugin.delete_all(:user_id => id)

      plugin_names.each_with_index do |plugin_name, index|
        plugins.create(:name => plugin_name, :position => index) if plugin_name.is_a?(String)
      end
    end
  end

  def authorized_plugins
    plugins.collect(&:name) | ::Refinery::Plugins.always_allowed.names
  end

  def add_role(title)
    if title.is_a? ::Role
      raise ArgumentException, "Role should be the title of the role not a role object."
    end

    roles << ::Role[title] unless has_role?(title)
  end

  def has_role?(title)
    if title.is_a? ::Role
      raise ArgumentException, "Role should be the title of the role not a role object."
    end

    roles.any? { |r| r.title == title.to_s.camelize}
  end

  def can_delete?(user_to_delete = self)
    user_to_delete.persisted? &&
      !user_to_delete.has_role?(:superuser) &&
      ::Refinery::Role[:refinery].users.any? &&
      id != user_to_delete.id
  end

  def can_edit?(user_to_edit = self)
    user_to_edit.persisted? && (user_to_edit == self || self.has_role?(:superuser))
  end

  def self.new_with_session(params, session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"], without_protection: true) do |user|
        user.attributes = params
      end
    else
      super
    end
  end

end
