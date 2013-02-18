class Shikashi::Privileges
  def allow_methods *args
    args.each { |m| allow_method m }
  end
end