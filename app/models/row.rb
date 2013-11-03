class Row
  include Mongoid::Document
  has_one :event
  belongs_to :table, index: true
  field :row_id, type: Moped::BSON::ObjectId
  index table_id: 1, row_id: 1

  before_create :set_ids
  after_create :add_to_gs_delayed

  def from_hash hash
    hash.symbolize_keys!.except!(:_id, :id, :table_id, :game_id)
    hash.each do |key, value|
      self[key]=value
    end
  end

  def set_ids
    self.row_id||=Moped::BSON::ObjectId.new
  end

  def add_to_gs_delayed
    self.delay(queue: "gs").add_to_gs
  end

  def add_to_gs
    m=Mon2table.new url: table.url
    m.export [self]
  end

end
