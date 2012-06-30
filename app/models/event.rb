class Event
  include Mongoid::Document

  field      :input , type: String

  field      :time  , type: Time
  belongs_to :user

  belongs_to :block , class_name: "Block", inverse_of: :events
  belongs_to :game  , class_name: "Game" , inverse_of: :descendant_events #auto

  belongs_to :parent, class_name: "Event", inverse_of: :children
  belongs_to :source, class_name: "Event", inverse_of: :descendants

  belongs_to :responsible_user, class_name: "User", inverse_of: nil
  field      :reason, type: String




  has_many :children, class_name: "Event", inverse_of: :parent
  has_many :descendants, class_name: "Event", inverse_of: :source
end
