class OtherMedia < Content
  
  # OtherMedia have no photos at all, so they never have a thumbnail.
  #
  def has_thumbnail?
    false
  end
  
end
