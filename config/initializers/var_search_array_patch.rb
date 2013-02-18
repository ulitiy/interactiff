class Array
  def var?
    self.count==3 && self[0]==:call && self[1]==nil
  end
  def var_search
    return [self[2].to_s] if var?
    reduce([]) do |arr,el|
      if el.is_a? Array
        arr+el.var_search
      else
        arr
      end
    end.uniq
  end
end
