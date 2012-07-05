class String
  def or_else(alternate)
    blank? ? alternate : self
  end
end
