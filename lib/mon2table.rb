require "google_drive"
class Mon2table
  TYPE_CONVERSION=Hash.new("to_s").merge h={"Integer" => "to_i", "Float" => "to_f", "Boolean" => "to_bool", "Time" => "to_time", "String" => "to_s"}

  def initialize url: nil
    @url=url
    @session=GoogleDrive.login "robot@interactiff.net", "Bv44g3y1"
    @spreadsheet=@session.spreadsheet_by_url(@url)
    @worksheet=@spreadsheet.worksheets[0]
  end

  #"https://docs.google.com/spreadsheet/ccc?key=0Au4e-jj1-69ZdE1vbGhTWnd4R3RfVm1KUlVRWHJtOGc&usp=sharing"

  def export collection, exclude: ["table_id", "_id"], truncate: false
    @truncate=truncate
    @exclude=exclude
    truncate ? truncate_worksheet : load_schema
    collection.each do |doc|
      doc_export doc
    end
  end

  def truncate_worksheet
    (1..@worksheet.num_rows).each do |i|
      (1..@worksheet.num_cols).each do |j|
        @worksheet[i,j]=nil
      end
    end
    @worksheet.save
    @schema={}
  end

  def doc_export doc
    row=get_row_by_id doc.row_id #keys#################
    doc.attributes.except(*@exclude).each do |name,value|
      set_value row: row, name: name, value: value
    end
    @worksheet.save()
  end

  def load_schema
    @schema={}
    (1..@worksheet.num_cols).each do |i|
      name=@worksheet[1,i]
      next if name !~ /\A[a-z][a-z0-9_]*\Z/i ##################
      @schema[name]={col: i, name: name, type: type=@worksheet[2,i].capitalize, conv: Mon2table::TYPE_CONVERSION[type]}
    end
  end

  def get_row_by_id id
    if @truncate
      get_col name: "row_id"
      row=@worksheet.num_rows+1
    else
      id=id.to_s
      col=get_col name: "row_id" ################
      (3..@worksheet.num_rows).each do |i|
        return i if @worksheet[i,col]==id
      end
      @worksheet.num_rows+1
    end
  end

  def set_value row: nil, name: nil, value: nil
    col=get_col name: name, value: value
    @worksheet[row,col]=value
  end

  def get_value row: nil, name: nil
    col=get_col name: name
    return nil if @worksheet[row,col].empty?
    @worksheet[row,col].send(@schema[name][:conv])
  end

  def get_col name: nil, value: nil
    type=value ? value.class.name : "String"
    if @schema[name]
      col=@schema[name][:col]
    else
      col=@worksheet.num_cols+1
      @schema[name]={col: col, name: name, type: type, conv: Mon2table::TYPE_CONVERSION[type]}
      @worksheet[1,col]=name
      @worksheet[2,col]=type
    end
    col
  end

  def import overwrite: {}, limit: nil, model: nil #overwrite table_id
    load_schema
    @model=model
    @overwrite=overwrite
    (3..@worksheet.num_rows).each do |i|
      import_row row: i
    end
  end

  def get_row_hash row
    h={}
    @schema.each do |name, _|
      h[name]=get_value name: name, row: row
    end
    h
  end

  def import_row key: [:table_id,:row_id], row: nil
    hash=get_row_hash row
    hash.symbolize_keys!.merge! @overwrite
    keypairs=key.map do |k|
      [k,hash[k]]
    end
    m=@model.where(Hash[keypairs]).first || @model.new
    m.from_hash hash
    m.import = true ##############
    m.save!
  end

end

class String
  def to_bool
    !!(self =~ /^(true|t|yes|y|1)$/i)
  end
end
