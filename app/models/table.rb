class Table
  include Mongoid::Document
  belongs_to :game, index: true
  field :name, type: String, default: ""
  field :url, type: String, default: "https://docs.google.com/spreadsheet/ccc?key=0Au4e-jj1-69ZdE1vbGhTWnd4R3RfVm1KUlVRWHJtOGc#gid=0"
  has_many :rows, dependent: :destroy

  index game_id: 1, name: 1

  def add hash
    row=rows.new
    hash.symbolize_keys!.except!(:_id, :id, :table_id, :game_id)
    row.from_hash(hash)
    row.save!
  end

  def export truncate: false
    Mon2table.new(url: url).export rows.order_by(row_id: 1), truncate: truncate
  end

  def import
    Mon2table.new(url: url).import model: Row, overwrite: {table_id: id}
  end
end
