class AddRowBlock < EvalBlock
  field :expression, type: String, default: ""
  field :table_name, type: String, default: ""
  field :url, type: String, default: ""
  belongs_to :table, class_name: "Table", inverse_of: nil, index: true

  before_save :set_table
  attr_accessible :expression, :variable, :table_name, :url

  # sets table
  def set_table
    if table_name.present?
      self.table=game.table(table_name)
      self.table.url=url
      self.table.save!
    end
  end

  # creates an event with variable value
  def create_event options
    row=table.add calculate_value(expression,options)
    super options.merge row: row
  end

end
