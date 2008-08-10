module CacheableUserInfo

  def write_user_info_to_cookie
    cookies['user_info'] = current_user.login
  end
  
  def destroy_user_info_cookie
    cookies.delete :user_info
  end
  
end
