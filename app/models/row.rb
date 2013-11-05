class Row
  include Mongoid::Document
  has_one :event
  belongs_to :table, index: true
  field :row_id, type: Moped::BSON::ObjectId
  index table_id: 1, row_id: 1

  before_create :set_ids
  after_create :export_delayed
  skip_callback :create, :after, :export_delayed, if: -> { @import }

  attr_accessor :import

  def from_hash hash
    hash.each do |key, value|
      if value
        self[key]=value
      else
        remove_attribute key
      end
    end
  end

  def set_ids
    self.row_id||=Moped::BSON::ObjectId.new
  end

  def export_delayed
    self.delay(queue: "gs").export
  end

  def export
    m=Mon2table.new url: table.url
    m.export [self]
  end

end
