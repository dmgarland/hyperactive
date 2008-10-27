module CacheableUserInfo

  def write_user_info_to_cookie
    unless current_user.is_anonymous?
      cookies['user_info'] = {:value => current_user.login, :expires => Time.now + 2.hours }
    end
  end
  
  def destroy_user_info_cookie
    cookies.delete :user_info
  end
  
end
