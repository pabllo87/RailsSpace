module ProfileHelper
  def profile_for(user)
    profile_url(:screen_name => user.screen_name)
  end
  
  def hide_edit_links?
    not @hide_edit_links.nil?
  end
end
