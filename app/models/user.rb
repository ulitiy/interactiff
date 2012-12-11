class User
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :roles, dependent: :destroy
  has_many :events, dependent: :destroy
  has_and_belongs_to_many :member_of_games, class_name: "Game", inverse_of: "members", index: true
  belongs_to :team, index: true
  #TODO: множественное присваивание

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  ## Confirmable
  # field :confirmation_token,   :type => String
  # field :confirmed_at,         :type => Time
  # field :confirmation_sent_at, :type => Time
  # field :unconfirmed_email,    :type => String # Only if using reconfirmable

  validates_presence_of :email
  validates_presence_of :encrypted_password

  # @return [Array] games, where the user is an author
  def games
    roles.map { |role| role.block if role.block.is_a?(Game) && role.access.in?([:manage,:manage_roles]) }.compact
  end

end
